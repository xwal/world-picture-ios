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

    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var cacheSizeLabel: UILabel!
    
    @IBOutlet weak var enableVoiceSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        if let bundleVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String, let shortVerson = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            versionLabel.text = "版本 \(shortVerson)(\(bundleVersion))"
        }
        
        enableVoiceSwitch.addTarget(self, action: #selector(voiceStateChanged(sender:)), for: .valueChanged)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(NGPVoiceStateChangedNotification), object: nil, queue: nil) { (notify) in
            
            self.enableVoiceSwitch.isOn = SpeechSynthesizerManager.sharedInstance.isEnabled
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func voiceStateChanged(sender: UISwitch) {
        SpeechSynthesizerManager.sharedInstance.isEnabled = sender.isOn
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ImageCache.default.calculateDiskCacheSize { (imageDiskCacheSize) in
            let totalCacheSize = imageDiskCacheSize + UInt(URLCache.shared.currentDiskUsage)
            self.cacheSizeLabel.text = String(format: "%.2f", (Double(totalCacheSize) / 1024 / 1024)) + "M"
        }
        
        enableVoiceSwitch.isOn = SpeechSynthesizerManager.sharedInstance.isEnabled
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
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
        else if indexPath.row == 3 {
            self.cacheSizeLabel.text = "0.0M"
            ImageCache.default.clearDiskCache()
            ImageCache.default.clearMemoryCache()
            URLCache.shared.removeAllCachedResponses()
        }
    }

}
