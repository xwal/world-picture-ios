//
//  ShareManager.swift
//  NationalGeographic
//
//  Created by Chaosky on 2016/11/18.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit

class ShareManager: NSObject {
    
    static func setupShareSDK() {
        
        ShareSDK.registerApp("192269c5c1100", activePlatforms:[
            SSDKPlatformType.typeSinaWeibo.rawValue,
            SSDKPlatformType.typeWechat.rawValue,
            SSDKPlatformType.typeQQ.rawValue,
            SSDKPlatformType.typeMail.rawValue,
            SSDKPlatformType.typeSMS.rawValue],
                             onImport: { (platform : SSDKPlatformType) in
                                switch platform
                                {
                                case .typeSinaWeibo:
                                    ShareSDKConnector.connectWeibo(WeiboSDK.classForCoder())
                                case .typeWechat:
                                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                                case .typeQQ:
                                    ShareSDKConnector.connectQQ(QQApiInterface.classForCoder(), tencentOAuthClass: TencentOAuth.classForCoder())
                                default:
                                    break
                                }
                                
        }) { (platform : SSDKPlatformType, appInfo : NSMutableDictionary?) in
            
            switch platform
            {
            case .typeSinaWeibo:
                //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                appInfo?.ssdkSetupSinaWeibo(byAppKey: "3670565384",
                                            appSecret : "1f15571e9b8b6f194ff6f4edacfbfb23",
                                            redirectUri : "http://chaosky.me/ngp",
                                            authType : SSDKAuthTypeBoth)
                
            case .typeWechat:
                //设置微信应用信息
                appInfo?.ssdkSetupWeChat(byAppId: "wx4868b35061f87885", appSecret: "64020361b8ec4c99936c0e3999a9f249")
                
            case .typeQQ:
                //设置QQ应用信息
                appInfo?.ssdkSetupQQ(byAppId: "1105837816",
                                     appKey : "NFrj9KR5DsF5XUuH",
                                     authType : SSDKAuthTypeBoth)
            default:
                break
            }
            
        }
    }
    
    static func share(text: String!, thumbImages: Any!, images: Any!, url: URL!, title: String!, type: SSDKContentType = .auto) {
        // 1.创建分享参数
        let shareParams = NSMutableDictionary()
        shareParams.ssdkSetupShareParams(byText: text,
                                          images: images,
                                          url: url,
                                          title : title,
                                          type : type)
        
        // 定制微信朋友圈的分享内容
        shareParams.ssdkSetupWeChatParams(byText: text, title: title, url: url, thumbImage: thumbImages, image: images, musicFileURL: nil, extInfo: nil, fileData: nil, emoticonData: nil, type: type, forPlatformSubType: .subTypeWechatTimeline)
        
        shareParams.ssdkSetupWeChatParams(byText: text, title: title, url: url, thumbImage: thumbImages, image: images, musicFileURL: nil, extInfo: nil, fileData: nil, emoticonData: nil, type: type, forPlatformSubType: .subTypeWechatSession)
        
        ShareSDK.showShareActionSheet(nil, items: nil, shareParams: shareParams) { (state, platformType, userData, contentEntity, error, end) in
            switch state {
                
            case SSDKResponseState.success:
                print("分享成功")
            case SSDKResponseState.fail:
                print("授权失败,错误描述:\(error)")
            case SSDKResponseState.cancel:
                print("操作取消")
                
            default:
                break
            }
        }
    }

}
