//
//  Utils.swift
//  NationalGeographic
//
//  Created by Chaosky on 2017/2/8.
//  Copyright © 2017年 ChaosVoid. All rights reserved.
//

import Foundation
import UIKit
import Photos
import MBProgressHUD

open class Utils : NSObject {
    
    open class func writeImageToPhotosAlbum(_ image: UIImage) {
        
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .denied {
            let alert = UIAlertController(title: "您已拒绝应用访问相册，是否手动开启？", message: nil, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let openAction = UIAlertAction(title: "开启", style: .default, handler: { (action) in
                UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(cancelAction)
            alert.addAction(openAction)
            UIApplication.currentViewController?.present(alert, animated: true, completion: nil)
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc private class func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeMutableRawPointer?) {
        
        guard let superView = UIApplication.shared.keyWindow else {
            return
        }
        
        let hud = MBProgressHUD.showAdded(to: superView, animated: true)
        hud.mode = .text
        
        if let error = error {
            hud.label.text = "保存失败，\(error.localizedDescription)"
        }
        else {
            hud.label.text = "已保存至相册"
        }
        hud.hide(animated: true, afterDelay: 0.5)
    }
}
