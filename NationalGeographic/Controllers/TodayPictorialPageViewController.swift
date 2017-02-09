//
//  TodayPictorialPageViewController.swift
//  NationalGeographic
//
//  Created by Chaosky on 2016/12/2.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit
import Alamofire
import YYCategories
import MBProgressHUD

class TodayPictorialPageViewController: UIPageViewController, UIPageViewControllerDataSource {

    var todayPictorialModel: TodayPictorialModel!
    
    var pictorialVCs = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(hexString: "2D363A")

        // Do any additional setup after loading the view.
        requestTodayPictorial()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func requestTodayPictorial() {
        
        weak var weakSelf = self
        
        self.loadingImageView.startAnimating()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayStr = dateFormatter.string(from: Date())
        
        let url = URL(string: String(format: NGPAPI_CHANYOUJI_DAY_PICTORIAL, todayStr))!
        let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 15)
        
        let sharedUserDefaults = UserDefaults(suiteName: "group.ngp.sharedDatas")
        let shareData = sharedUserDefaults?.data(forKey: todayStr)
        
        let cacheResponse = URLCache.shared.cachedResponse(for: request)
        let cacheData = cacheResponse?.data
        
        if shareData != nil && cacheData == nil {
            let response = URLResponse(url: url, mimeType: "applcation/json", expectedContentLength: shareData!.count, textEncodingName: "utf-8")
            let cacheResponse = CachedURLResponse(response: response, data: shareData!)
            URLCache.shared.storeCachedResponse(cacheResponse, for: request)
        }
        
        Alamofire.request(request).responseJSON { (response) in
            if let JSON = response.result.value {
                weakSelf?.todayPictorialModel = TodayPictorialModel.yy_model(withJSON: JSON)
                if shareData == nil {
                    sharedUserDefaults?.set(self.todayPictorialModel.yy_modelToJSONData(), forKey: todayStr)
                    sharedUserDefaults?.synchronize()
                }
                DispatchQueue.main.async {
                    weakSelf?.updateViews()
                    weakSelf?.loadingImageView.stopAnimating()
                }
            }
            else {
                DispatchQueue.main.async {
                    weakSelf?.loadingImageView.stopAnimating()
                    
                    let hud = MBProgressHUD.showAdded(to: (weakSelf?.view)!, animated: true)
                    hud.mode = .text
                    hud.label.text = "加载失败，即将关闭当前页面"
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: { 
                        hud.hide(animated: true)
                        weakSelf?.dismiss(animated: true, completion: nil)
                    })
                }
            }
        }
    }
    
    func updateViews() {
        
        pictorialVCs.removeAll()
        
        self.dataSource = self
        
        let todayWallPaperVC = self.storyboard?.instantiateViewController(withIdentifier: "TodayWallpaperViewController") as! TodayWallpaperViewController
        todayWallPaperVC.wallpapperModel = self.todayPictorialModel
        
        pictorialVCs.append(todayWallPaperVC)
        
        if let articles = todayPictorialModel.articles {
            for article in articles {
                let articleDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ArticleDetailViewController") as! ArticleDetailViewController
                articleDetailVC.articleModel = article
                pictorialVCs.append(articleDetailVC)
            }
        }
        
        
        
        self.setViewControllers([todayWallPaperVC], direction: .forward, animated: false, completion: nil)
    }
    
    // MARK: UIPageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = self.pictorialVCs.index(of: viewController)!
        let beforeIndex = currentIndex - 1
        
        return beforeIndex >= 0 ? self.pictorialVCs[beforeIndex] : nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = self.pictorialVCs.index(of: viewController)!
        let afterIndex = currentIndex + 1
        
        return afterIndex >= self.pictorialVCs.count ? nil : self.pictorialVCs[afterIndex]
    }

}
