//
//  SettingViewController.swift
//  NationalGeographic
//
//  Created by Chaosky on 2016/12/19.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit
import Kingfisher
class SettingViewController: UITableViewController {

    @IBOutlet weak var cacheSizeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ImageCache.default.calculateDiskCacheSize { (size) in
            
            self.cacheSizeLabel.text = String(format: "%.2f", (Double(size) / 1024 / 1024)) + "M"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 1 {
            if let itunesURL = URL(string: "https://itunes.apple.com/us/app/shi-jie-de-li-hua-bao/id1178885979?l=zh&ls=1&mt=8") {
                UIApplication.shared.openURL(itunesURL)
            }
        }
        else if indexPath.row == 2 {
            self.cacheSizeLabel.text = "0.0M"
            ImageCache.default.clearDiskCache()
            ImageCache.default.clearMemoryCache()
        }
    }

}
