//
//  AppDelegate.swift
//  WorldPicture
//
//  Created by Chaosky on 2016/11/15.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit
import AVOSCloud
import UserNotifications
import IQKeyboardManagerSwift
import DateToolsSwift
import AVFoundation
import Alamofire
import SwiftyJSON
import StoreKit
import Firebase
import SwiftyStoreKit
#if DEBUG
import FLEX
#endif

private let TodayWallpaperLocalNotificationIdentifier = "tech.chaosky.UserNotification.TodayWallpaper"
private let kAppLaunchTime = "AppLaunchTime"
private let kLastVersion = "LastVersion"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    
    private var _appLaunchCount: Int = -1
    
    var appLaunchCount: Int {
        get {
            if (_appLaunchCount < 0) {
                _appLaunchCount = UserDefaults.standard.integer(forKey: kAppLaunchTime)
            }
            return _appLaunchCount
        }
        set {
            UserDefaults.standard.set(newValue, forKey: kAppLaunchTime)
        }
    }
    
    lazy var isNewVersionLaunch: Bool = {
        let lastVersion = UserDefaults.standard.string(forKey: kLastVersion)
        let infoDict = Bundle.main.infoDictionary
        let currentVersion = infoDict?["CFBundleShortVersionString"] as? String
        let isNewVersionLaunch = lastVersion != currentVersion
        if isNewVersionLaunch {
            appLaunchCount = 1
            UserDefaults.standard.set(currentVersion, forKey: kLastVersion)
        }
        return isNewVersionLaunch
    }()
    
    // MARK: Life Cycle
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        openLog(true)
        
        // URL Cahche
        URLCache.shared.diskCapacity = 100 * 1024 * 1024 // 100M
        URLCache.shared.memoryCapacity = 100 * 1024 * 1024 // 100M
        
        // 第三方服务
        
        // Firebase
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        AVOSCloud.setApplicationId("FTg9Sm3twoAW1eROhglmob8B-gzGzoHsz",
                                   clientKey: "JepbTwaiwvytDd2IUV7uH259",
                                   serverURLString: "https://api.worldpicture.chaosky.tech")
        
        // 百度语音配置
        SpeechSynthesizerManager.sharedInstance.setupBDSpeech()
        
        // 键盘输入
        IQKeyboardManager.shared.enable = true
        
        
        // App 设置
        
        // 设置样式
        setupAppearance()
        
        // 设置HandOff
        setupUserActivity()
        
        // 设置通知
        setupUserNotification()
        
        // 更新版本
        updateAppVersion()
        
        // 设置StoreKit
        setupStore()
        
        _ = isNewVersionLaunch
        
        appLaunchCount += 1
        
        #if DEBUG
        FLEXManager.shared()?.showExplorer()
        #endif
        
        return true
    }
    
    func setupStore() {
        if #available(iOS 10.3, *), appLaunchCount == 10 {
            SKStoreReviewController.requestReview()
        }
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    // Unlock content
                case .failed, .purchasing, .deferred:
                    break // do nothing
                @unknown default:
                    fatalError()
                }
            }
        }
    }
    
    func setupUserActivity() {
        userActivity = NSUserActivity(activityType: "tech.chaosky.WorldPicture.OpenSafari")
        userActivity?.title = "Chaosky 博客"
        userActivity?.becomeCurrent()
        userActivity?.webpageURL = URL(string: "http://chaosky.tech")
    }
    
    func openLog(_ isOpen: Bool) {
        if isOpen {
            print("===========================")
            // 打印 Bundle 路径
            print("bundle url: \(Bundle.main.bundleURL)")
            // 沙盒路径
            print("sandbox url: \(NSHomeDirectory())")
        }
    }
    
    func setupUserNotification() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                // 用户允许通知
                self.createEverydayNotification()
            }
        }
    }
    
    func createEverydayNotification() {
        // 创建通知
        // 1. 创建通知内容
        let content = UNMutableNotificationContent()
        content.title = "每日壁纸"
        content.body = "今日壁纸已经为您准备好！"
        content.sound = UNNotificationSound(named: convertToUNNotificationSoundName("notification.caf"))
        
        // 2. 创建发送触发
        let dateComponents = DateComponents(hour: 9)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // 3. 发送请求标识符
        let requestIdentifier = TodayWallpaperLocalNotificationIdentifier
        
        // 4. 创建一个发送请求
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        
        // 将请求添加到发送中心
        UNUserNotificationCenter.current().add(request) { error in
            if error == nil {
                print("TodayWallpaper Notification scheduled: \(requestIdentifier)")
            }
        }
    }
    
    // MARK: - UNUserNotificationCenterDelegate
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == TodayWallpaperLocalNotificationIdentifier {
            showTodayWallpaper()
        }
        completionHandler()
    }
    
    func setupAppearance() {
        UITabBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)]
        UINavigationBar.appearance().tintColor = .white
    }
    
    func showTodayWallpaper() {
        
    }
    
    func showTodayGeographic() {
        
        let initDate = Date(year: 2013, month: 1, day: 17)
        let days = initDate.daysAgo
        
        if days < 178 {
            return
        }
        
        if let currentVC = UIApplication.currentViewController as? DiliDetailViewController {
            currentVC.albumID = String(days)
            currentVC.requestAlbumDetail()
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                let todayGeographicVC = StoryboardScene.Dili.albumDetailViewController.instantiate()
                todayGeographicVC.albumID = String(days)
                todayGeographicVC.modalPresentationStyle = .fullScreen
                UIApplication.currentViewController?.present(todayGeographicVC, animated: true, completion: nil)
            })
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.scheme == "worldpicture" && url.host == "TodayWallpaper" {
            showTodayWallpaper()
            return true
        }
        return true
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        application.applicationIconBadgeNumber -= 1
        
        //开启后台处理多媒体事件
        UIApplication.shared.beginReceivingRemoteControlEvents()
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setActive(true)
        //后台播放
        try? audioSession.setCategory(.playback, mode: .default, options: [])
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        if shortcutItem.type == "TodayGeographic" {
            showTodayGeographic()
        }
        
        if shortcutItem.type == "TodayWallpaper" {
            showTodayWallpaper()
        }
    }
    
    func updateAppVersion() {
        
        let reminderDate = UserDefaults.standard.double(forKey: NGPVersionReminderDateKey)
        let nowDate = Date().timeIntervalSince1970
        if nowDate - reminderDate < NGPThreeDaySeconds  {
            return
        }
        
        AF.request("https://itunes.apple.com/CN/lookup?id=1483196698").responseJSON { (response) in
            if let data = try? response.result.get() {
                
                let json = JSON(data)
                let itunesVersion = json["results"][0]["version"].stringValue
                
                let appVersion = JSON(Bundle.main.infoDictionary!)["CFBundleShortVersionString"].stringValue
                
                guard itunesVersion.compare(appVersion,
                                            options: NSString.CompareOptions.caseInsensitive) == .orderedDescending else {
                    return
                }
                
                let notes = json["results"][0]["releaseNotes"].string
                let url = json["results"][0]["trackViewUrl"].stringValue
                
                let alert = UIAlertController(title: "新版本升级", message: notes, preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "暂不升级", style: .cancel, handler: { (action) in
                    UserDefaults.standard.set(nowDate, forKey: NGPVersionReminderDateKey)
                    UserDefaults.standard.synchronize()
                })
                
                let okAction = UIAlertAction(title: "马上体验", style: .default, handler: { (action) in
                    UIApplication.shared.open(URL(string: url)!)
                })
                
                alert.addAction(cancelAction)
                alert.addAction(okAction)
                
                self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
        
    }
}

extension UIWindow {
    open override var canBecomeFirstResponder: Bool {
        return true
    }
    
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        let enabled = SpeechSynthesizerManager.sharedInstance.isEnabled
        
        let text: String!
        if enabled {
            text = "语音朗读已关闭"
        }
        else {
            text = "语音朗读已开启"
        }
        
        SpeechSynthesizerManager.sharedInstance.speak(promptSentence: text)
        SpeechSynthesizerManager.sharedInstance.isEnabled = !enabled
        print("摇一摇")
        NotificationCenter.default.post(name: NSNotification.Name(NGPVoiceStateChangedNotification), object: nil, userInfo: nil)
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUNNotificationSoundName(_ input: String) -> UNNotificationSoundName {
	return UNNotificationSoundName(rawValue: input)
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}
