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

class SettingViewController: UITableViewController {

    @IBOutlet weak var versionLabel: UILabel!
    
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
    
    @objc func voiceStateChanged(sender: UISwitch) {
        SpeechSynthesizerManager.sharedInstance.isEnabled = sender.isOn
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        
        if indexPath.row == 0 {
            if let itunesURL = URL(string: "https://itunes.apple.com/us/app/%E4%B8%96%E7%95%8C%E7%94%BB%E6%8A%A5-%E6%9C%80%E7%BE%8E%E7%94%BB%E6%8A%A5%E9%9B%86/id1295152519?l=zh&ls=1&mt=8") {
                UIApplication.shared.openURL(itunesURL)
            }
        }
        else if indexPath.row == 2 {
            let alertView = UIAlertController(title: nil, message: "清除缓存", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
                alertView.dismiss(animated: true, completion: nil)
            })
            
            let okAction = UIAlertAction(title: "确定", style: .default, handler: { (action) in
                ImageCache.default.clearMemoryCache()
                ImageCache.default.clearDiskCache()
            })
            alertView.addAction(cancelAction)
            alertView.addAction(okAction)
            
            self.present(alertView, animated: true, completion: nil)
        }
    }

}
