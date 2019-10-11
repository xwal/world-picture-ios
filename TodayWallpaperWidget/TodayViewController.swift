//
//  TodayViewController.swift
//  TodayWallpaperWidget
//
//  Created by Chaosky on 2016/12/12.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit
import NotificationCenter
import Alamofire
import Kingfisher

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var wallpaperImageView: UIImageView!
    
    @IBOutlet weak var todayLabel: UILabel!
    
    @IBOutlet weak var monthLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var destinationLabel: UILabel!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var bottomView: UIView!
    
    var todayPictorialModel: TodayPictorialModel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        print(NSHomeDirectory())
        setupViews()
        requestTodayPictorial()
    }
    
    func requestTodayPictorial() {
        
        self.loadingImageView.startAnimating()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayStr = dateFormatter.string(from: Date())
        
        let url = URL(string: String(format: NGPAPI_CHANYOUJI_DAY_PICTORIAL, todayStr))!
        let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 15)
        
        let sharedUserDefaults = UserDefaults(suiteName: "group.WorldPicture.sharedDatas")
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
                self.todayPictorialModel = TodayPictorialModel.yy_model(withJSON: JSON)
                if shareData == nil {
                    sharedUserDefaults?.set(self.todayPictorialModel.yy_modelToJSONData(), forKey: todayStr)
                    sharedUserDefaults?.synchronize()
                }
                
                DispatchQueue.main.async {
                    self.updateViews()
                    self.loadingImageView.stopAnimating()
                }
            }
            else {
                DispatchQueue.main.async {
                    self.loadingImageView.stopAnimating()
                }
            }
        }
    }
    
    func setupViews() {
        
        self.view.backgroundColor = UIColor.clear
        
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        
        topView.layer.contents = Image(named: "Navbar_mask")?.cgImage
        bottomView.layer.contents = Image(named: "TopMask")?.cgImage
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        
        dateFormatter.dateFormat = "dd"
        let day = dateFormatter.string(from: Date())
        
        dateFormatter.dateFormat = "MMMM"
        let month = dateFormatter.string(from: Date())
        
        todayLabel.text = day
        monthLabel.text = month
        titleLabel.text = "今日壁纸"
        
        self.wallpaperImageView.contentMode = .scaleAspectFill
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        self.wallpaperImageView.isUserInteractionEnabled = true
        self.wallpaperImageView.addGestureRecognizer(tapGesture)
        
    }
    
    @objc private func onTap() {
        self.extensionContext?.open(URL(string: "worldpicture://TodayWallpaper")!, completionHandler: nil)
    }
    
    func updateViews() {
        titleLabel.text = todayPictorialModel.title
        destinationLabel.text = "每日壁纸 — \(todayPictorialModel.destination ?? "")"
        
        if let imageURL = todayPictorialModel.ios_wallpaper_url {
            wallpaperImageView.kf.setImage(with: URL(string: imageURL), options: [.transition(.fade(0.5))])
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets()
    }
    
    @available(iOSApplicationExtension 10.0, *)
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if (activeDisplayMode == .compact) {
            self.preferredContentSize = maxSize
        }
        else {
            self.preferredContentSize = CGSize(width: 0, height: UIScreen.main.bounds.size.height)
        }
    }
    
}
