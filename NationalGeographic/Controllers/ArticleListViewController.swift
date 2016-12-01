//
//  ArticleListViewController.swift
//  NationalGeographic
//
//  Created by Chaosky on 2016/11/21.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit
import Alamofire
import YYCategories
import MJRefresh

private let reuseIdentifier = "PictorialCell"

class ArticleListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var pictorialArray = [PictorialModel]()
    
    var articleSelectIndex = 0
    var articleSelectModelArray = [PictorialArticleModel]()
    
    lazy var loadingImageView: UIImageView = {
        let loadingImageView = UIImageView()
        self.view.addSubview(loadingImageView)
        var animationImages = [UIImage]()
        for index in 1...32 {
            
            if let image = UIImage(named: "loading_\(index)") {
                animationImages.append(image)
            }
        }
        loadingImageView.animationImages = animationImages
        
        loadingImageView.snp.makeConstraints { (maker) in
            maker.center.equalTo(self.view)
        }
        return loadingImageView
    }()
    
    private var cacheDataURL: URL {
        
        return UIApplication.shared.documentsURL.appendingPathComponent("ArticleListModel.data")
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didSelectEasyCell(_:)), name: NSNotification.Name(rawValue: DidSelectEasyCellNotification), object: nil)
        setupCacheData()
    }
    
    func setupView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.requestPictorialList()
        })
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func didSelectEasyCell(_ sender: NSNotification) {
        
        guard let models = sender.userInfo?["Models"] as? [PictorialArticleModel] else {
            return
        }
        
        guard let selectIndex = sender.userInfo?["Index"] as? Int else {
            return
        }
        
        articleSelectModelArray = models
        articleSelectIndex = selectIndex
        
        self.performSegue(withIdentifier: "PresentArticlePage", sender: nil)
    }
    
    
    
    func requestPictorialList() {
        loadingImageView.startAnimating()
//        http://chanyouji.com/api/pictorials/articles.json
//        http://7xooko.com1.z0.glb.clouddn.com/ngp/pictorials/articles.json
        
        Alamofire.request("http://chanyouji.com/api/pictorials/articles.json").responseJSON { (response) in
            if let JSON = response.result.value {
                self.pictorialArray = NSArray.yy_modelArray(with: PictorialModel.self, json: JSON) as! [PictorialModel]
                self.updateCacheData()
            }
            
            DispatchQueue.main.async {
                self.tableView.mj_header.endRefreshing()
                self.loadingImageView.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupCacheData() {
        do {
            let cacheJSONData = try Data(contentsOf: cacheDataURL)
            pictorialArray = NSArray.yy_modelArray(with: PictorialModel.self, json: cacheJSONData) as! [PictorialModel]
            tableView.reloadData()
        } catch {
            requestPictorialList()
        }
    }
    
    func updateCacheData() {
        // 将数据写入本地
        if let data = (self.pictorialArray as NSArray).yy_modelToJSONData() {
            do {
                try data.write(to: self.cacheDataURL)
            } catch let error {
                print(error)
            }
        }
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictorialArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! PictorialCell

        let model = pictorialArray[indexPath.row]
        
        cell.model = model

        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PresentArticlePage" {
            let articlePageVC = segue.destination as! ArticlePageViewController
            articlePageVC.selectedIndex = articleSelectIndex
            articlePageVC.articleModelArray = articleSelectModelArray
        }
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        
        guard pictorialArray.count > 0 else {
            return
        }
        
        let randomPictorialIndex = Int(arc4random_uniform(UInt32(pictorialArray.count)))
        
        guard let articles = pictorialArray[randomPictorialIndex].articles else {
            return
        }
        
        articleSelectIndex = Int(arc4random_uniform(UInt32(articles.count)))
        articleSelectModelArray = articles
        self.performSegue(withIdentifier: "PresentArticlePage", sender: nil)
    }

}
