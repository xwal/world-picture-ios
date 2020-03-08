//
//  TerminalStatisticsH5ViewController.swift
//  GXM-CRM
//
//  Created by jsonmess on 2017/11/22.
//  Copyright © 2017年 GuoXiaoMei. All rights reserved.
//

import SnapKit
import UIKit
import WebKit
import MJRefresh
import RxSwift
import RxCocoa

// 页面加载状态
enum LoadingStatus: Int {
    // 初始状态
    case initial = 0
    // 加载中..
    case inLoading = 1
    // 加载完成
    case success = 2
    // 加载失败
    case faild = 3
}

class WebViewController: BaseViewController {
    
    private static let uniqueProcessPool = WKProcessPool()

    private let url: URL
    
    private var operation = WebOperations()
    private let commonMessageHandler = CommonMessageHandler()
    private let commonMessageNames = ["onDidMount", "onDidDismiss"]
    
    private var webView: WKWebView!
    private var progressView: UIProgressView!
    private var hud: HUD!
    
    var isHome = false
    var isMounted = false
    var hasPullRefresh = false
    
    typealias MessageHandler = (name: String, handler: WKScriptMessageHandler)
    
    var messageHandlers: [MessageHandler] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addObservers()
        reload()
    }
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        let userContentController = webView.configuration.userContentController
        commonMessageNames.forEach { userContentController.removeScriptMessageHandler(forName: $0) }
        messageHandlers.forEach { userContentController.removeScriptMessageHandler(forName: $0.name) }
        webView = nil
    }
    
    @objc func videoDidRotate() {
        self.setNeedsStatusBarAppearanceUpdate()
    }

    override var prefersStatusBarHidden: Bool {
        return UIApplication.shared.statusBarOrientation.isLandscape
    }
    
    private func setupView() {
        
        let configuration = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        commonMessageHandler.webViewController = self
        commonMessageNames.forEach { userContentController.add(commonMessageHandler, name: $0) }
        
        messageHandlers.forEach { userContentController.add($0.handler, name: $0.name) }
        
        configuration.processPool = WebViewController.uniqueProcessPool
        configuration.userContentController = userContentController
        
        let mWebView = WKWebView(frame: CGRect.zero, configuration: configuration)
        webView = mWebView
        mWebView.uiDelegate = self
        mWebView.navigationDelegate = self
        mWebView.allowsBackForwardNavigationGestures = true
        view.addSubview(mWebView)
        mWebView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // ProgressView
        let mProgressView = UIProgressView(frame: CGRect.zero)
        progressView = mProgressView
        mProgressView.progress = 0.0
        mProgressView.progressTintColor = .red
        mProgressView.backgroundColor = UIColor.clear
        mProgressView.trackTintColor = UIColor.clear
        view.addSubview(mProgressView)
        mProgressView.snp.makeConstraints { maker in
            maker.trailing.leading.equalToSuperview()
            maker.top.equalToSuperview()
            maker.height.equalTo(2.0)
        }
        
        hud = HUD(container: view)
        
        if hasPullRefresh {
            let header = MJRefreshNormalHeader { [weak self] in
                self?.reload()
            }
            header.stateLabel?.isHidden = true
            mWebView.scrollView.mj_header = header
        }
    }
    
    // MARK: Observer
    private func addObservers() {
        self.webView.rx.observeWeakly(String.self, "title").subscribe(onNext: { [weak self] (title) in
            guard let self = self else { return }
            if self.isHome {
                self.navigationItem.title = self.webView.title
            } else {
                self.title = self.webView.title
            }
        }).disposed(by: disposeBag)
        
        self.webView.rx.observeWeakly(Double.self, "estimatedProgress").subscribe(onNext: { [weak self] _ in
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                if let progres = self?.webView.estimatedProgress {
                  self?.progressView?.progress = Float(progres)
                }
            }, completion: nil)
        }).disposed(by: disposeBag)
    }
    
    //UI显示加载  状态机
    private func updateShow(status: LoadingStatus) {
        switch status {
        case .initial:
            self.webView.isHidden = false
            self.progressView?.isHidden = false
            self.progressView?.progress = 0.0
        case .inLoading:
            self.webView.isHidden = false
            self.progressView?.isHidden = false
        case .success:
            self.webView.isHidden = false
            self.progressView?.isHidden = true
        case .faild:
            self.webView.isHidden = true
            self.progressView?.isHidden = true
        }
        
        switch status {
        case .initial:
            hud.show()
        case .inLoading:
            break
        case .success, .faild:
            if hasPullRefresh {
                self.webView.scrollView.mj_header?.endRefreshing()
            }
            hud.hide()
        }
    }
    
    // 加载 request
    func loadRequest(_ loadUrl: URL) {
        updateShow(status: .initial)
        let request = URLRequest(url: loadUrl, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 15)
        webView?.load(request)
    }
    
    // 重新加载
    @objc func reload() {
        updateShow(status: .initial)
        if webView.url != nil {
            webView.reload()
        } else {
            loadRequest(url)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mountDidFinished() {
        
    }
    
}

/// Delegate
extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        updateShow(status: .inLoading)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        updateShow(status: .success)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        updateShow(status: .faild)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        updateShow(status: .faild)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let actionPolicy = self.operation.checkAndBlockInternalUrlScheme(request: navigationAction.request)
        if let url = navigationAction.request.url, actionPolicy == .cancel {
            UIApplication.shared.open(url)
        }
        decisionHandler(actionPolicy)
        
        // 延迟0.1秒检查返回
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            // 设置返回按钮
            if self.isHome {
                if webView.canGoBack {
                } else {
                    self.navigationItem.leftBarButtonItem = nil
                }
            }
        })
    }
}

extension WebViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .cancel, handler: { _ in
            completionHandler()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in
            completionHandler(true)
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { _ in
            completionHandler(false)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alert = UIAlertController(title: title, message: prompt, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = defaultText
        }
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in
            let inputText = alert.textFields?.first?.text
            completionHandler(inputText)
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { _ in
            completionHandler(nil)
        }))
        present(alert, animated: true, completion: nil)
    }
}

private class CommonMessageHandler: NSObject, WKScriptMessageHandler {
    
    weak var webViewController: WebViewController?
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "onDidMount" {
            webViewController?.isMounted = true
            webViewController?.mountDidFinished()
        } else if message.name == "onDidDismiss" {
            
            if webViewController?.isBeingPresented ?? true {
                webViewController?.dismiss(animated: true, completion: nil)
            } else {
                webViewController?.navigationController?.popViewController(animated: true)
            }
        }
    }
}
