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
import YYCategories

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
        
        weak var weakSelf = self
        
        self.loadingImageView.startAnimating()
        //        http://chanyouji.com/api/pictorials/2016-12-02.json
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayStr = dateFormatter.string(from: Date())
        Alamofire.request("http://chanyouji.com/api/pictorials/\(todayStr).json").responseJSON { (response) in
            if let JSON = response.result.value {
                weakSelf?.todayPictorialModel = TodayPictorialModel.yy_model(withJSON: JSON)
                DispatchQueue.main.async {
                    weakSelf?.updateViews()
                    weakSelf?.loadingImageView.stopAnimating()
                }
            }
            else {
                DispatchQueue.main.async {
                    weakSelf?.loadingImageView.stopAnimating()
                }
            }
        }
    }
    
    func setupViews() {
        
        self.view.backgroundColor = UIColor.clear
        
        if #available(iOSApplicationExtension 10.0, *) {
            self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
            
        } else {
            // Fallback on earlier versions
        }
        
        let tapGesture = UITapGestureRecognizer { (gesture) in
            self.extensionContext?.open(URL(string: "ngp://TodayWallpaper")!, completionHandler: nil)
        }
        self.view.addGestureRecognizer(tapGesture)
        
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
        
    }
    
    func updateViews() {
        titleLabel.text = todayPictorialModel.title
        destinationLabel.text = "每日壁纸 — \(todayPictorialModel.destination ?? "")"
        
        if let imageURL = todayPictorialModel.ios_wallpaper_url {
            wallpaperImageView.kf.setImage(with: URL(string: imageURL))
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
