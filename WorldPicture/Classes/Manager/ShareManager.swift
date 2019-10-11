//
//  ShareManager.swift
//  WorldPicture
//
//  Created by Chaosky on 2016/11/18.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit
import MBProgressHUD

class ShareManager: NSObject {
    
    static func setupShareSDK() {
        ShareSDK.registPlatforms { (register) in
            register?.setupSinaWeibo(withAppkey: "3670565384",
                                     appSecret: "1f15571e9b8b6f194ff6f4edacfbfb23",
                                     redirectUrl: "http://chaosky.tech/workspace/ngp")
            register?.setupWeChat(withAppId: "wxf5f2c3c207a84486", appSecret: "95aedc2d4152214f49137fb94b54fd16")
            register?.setupQQ(withAppId: "1105837816", appkey: "NFrj9KR5DsF5XUuH")
        }
    }
    
    static func shareActionSheet(text: String!, thumbImages: Any!, images: Any!, url: URL!, title: String!, type: SSDKContentType = .auto) {
        // 1.创建分享参数
        let shareParams = NSMutableDictionary()
        shareParams.ssdkSetupShareParams(byText: text,
                                          images: images,
                                          url: url,
                                          title : title,
                                          type : type)
        
        // 定制微信朋友圈的分享内容
        shareParams.ssdkSetupWeChatParams(byText: text, title: title, url: url, thumbImage: thumbImages, image: images, musicFileURL: nil, extInfo: nil, fileData: nil, emoticonData: nil, sourceFileExtension: nil, sourceFileData: nil, type: type, forPlatformSubType: .subTypeWechatTimeline)
        
        shareParams.ssdkSetupWeChatParams(byText: text, title: title, url: url, thumbImage: thumbImages, image: images, musicFileURL: nil, extInfo: nil, fileData: nil, emoticonData: nil, sourceFileExtension: nil, sourceFileData: nil, type: type, forPlatformSubType: .subTypeWechatSession)
        
        ShareSDK.showShareActionSheet(nil, customItems: nil, shareParams: shareParams, sheetConfiguration: nil) { (state, platformType, userData, contentEntity, error, end) in
            showShareState(state: state, error: error)
        }
    }
    
    static func shareNoUI(text: String!, thumbImages: Any!, images: Any!, url: URL!, title: String!, type: SSDKContentType = .auto, platformType: SSDKPlatformType = .typeAny) {
        //创建分享参数
        let shareParams = NSMutableDictionary()
        shareParams.ssdkSetupShareParams(byText: text,
                                         images: images,
                                         url: url,
                                         title : title,
                                         type : type)
        
        // 定制微信朋友圈的分享内容
        shareParams.ssdkSetupWeChatParams(byText: text, title: title, url: url, thumbImage: thumbImages, image: images, musicFileURL: nil, extInfo: nil, fileData: nil, emoticonData: nil, sourceFileExtension: nil, sourceFileData: nil, type: type, forPlatformSubType: .subTypeWechatTimeline)
        
        shareParams.ssdkSetupWeChatParams(byText: text, title: title, url: url, thumbImage: thumbImages, image: images, musicFileURL: nil, extInfo: nil, fileData: nil, emoticonData: nil, sourceFileExtension: nil, sourceFileData: nil, type: type, forPlatformSubType: .subTypeWechatSession)
        
        //进行分享
        ShareSDK.share(platformType, parameters: shareParams) { (state, userData, contentEntity, error) in
            showShareState(state: state, error: error)
        }
    }
    
    private static func showShareState(state: SSDKResponseState, error: Error?) {
        var msg = ""
        switch state {
        case .begin:
            print("分享开始")
            msg = "分享开始"
        case .success:
            print("分享成功")
            msg = "分享成功"
        case .fail:
            print("授权失败,错误描述:\(error?.localizedDescription ?? "")")
            msg = "授权失败,错误描述:\(error?.localizedDescription ?? "")"
        case .cancel:
            print("取消分享")
            msg = "取消分享"
        default:
            break
        }
        
        let keyWindow: UIWindow! = UIApplication.shared.keyWindow
        let hud = MBProgressHUD.showAdded(to: keyWindow, animated: true)
        
        if state == .begin {
            hud.mode = .indeterminate
            hud.label.text = "分享中..."
        }
        else {
            hud.mode = .text
            hud.label.text = msg
            hud.hide(animated: true, afterDelay: 1)
        }
    }

}
