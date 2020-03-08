//
//  SettingViewController.swift
//  WorldPicture
//
//  Created by Chaosky on 2016/12/19.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit
import Kingfisher
import MBProgressHUD
import SafariServices
import SwiftyStoreKit

class SettingViewController: UITableViewController {

    @IBOutlet weak var versionLabel: UILabel!
    
    @IBOutlet weak var enableVoiceSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        if let bundleVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String, let shortVerson = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            versionLabel.text = "版本 \(shortVerson)(\(bundleVersion))"
        }
        
        enableVoiceSwitch.addTarget(self, action: #selector(voiceStateChanged(sender:)), for: .valueChanged)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(NGPVoiceStateChangedNotification), object: nil, queue: nil) { [weak self] (notify) in
            guard let self = self else { return }
            self.enableVoiceSwitch.isOn = SpeechSynthesizerManager.sharedInstance.isEnabled
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func voiceStateChanged(sender: UISwitch) {
        SpeechSynthesizerManager.sharedInstance.isEnabled = sender.isOn
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        enableVoiceSwitch.isOn = SpeechSynthesizerManager.sharedInstance.isEnabled
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            let hudView = MBProgressHUD.showAdded(to: view, animated: true)
            hudView.mode = .indeterminate
            SwiftyStoreKit.purchaseProduct("tech.chaosky.WorldPicture.buydrinks") { result in
                switch result {
                case let .success(purchase):
                    print("Purchase Success: \(purchase.productId)")
                case let .error(error):
                    print(error.localizedDescription)
                }
                hudView.hide(animated: true)
            }
        case 1:
            if let itunesURL = URL(string: "https://itunes.apple.com/us/app/id1483196698?l=zh&ls=1&mt=8") {
                UIApplication.shared.open(itunesURL)
            }
        case 3:
            let alertView = UIAlertController(title: nil, message: "清除缓存", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: { _ in
                alertView.dismiss(animated: true, completion: nil)
            })
            
            let okAction = UIAlertAction(title: "确定", style: .default, handler: { _ in
                ImageCache.default.clearMemoryCache()
                ImageCache.default.clearDiskCache()
            })
            alertView.addAction(cancelAction)
            alertView.addAction(okAction)
            
            present(alertView, animated: true, completion: nil)
        case 4:
            guard let url = URL(string: "https://file.wp.chaosky.tech/b70adb4f85f2bd0e0d14/privacy_policy.html") else { return }
            let webVC = WebViewController(url: url)
            webVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(webVC)
        default:
            break
        }
    }

}
