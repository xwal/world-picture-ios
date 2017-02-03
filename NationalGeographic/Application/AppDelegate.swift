//
//  AppDelegate.swift
//  NationalGeographic
//
//  Created by Chaosky on 2016/11/15.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit
import YYCategories
import AVOSCloud
import AVOSCloudCrashReporting
import UserNotifications
import IQKeyboardManagerSwift
import DateTools
import AVFoundation

private let TodayWallpaperLocalNotificationIdentifier = "me.chaosky.UserNotification.TodayWallpaper"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func openLog(_ isOpen: Bool) {
        if isOpen {
            print("===========================")
            // 打印 Bundle 路径
            print("bundle url: \(Bundle.main.bundleURL)")
            // 沙盒路径
            print("sandbox url: \(UIApplication.shared.documentsURL)")
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        openLog(true)
        
        // URL Cahche
        URLCache.shared.diskCapacity = 100 * 1024 * 1024 // 100M
        URLCache.shared.memoryCapacity = 100 * 1024 * 1024 // 100M
        
        // Enable Crash Reporting
        AVOSCloudCrashReporting.enable()
        
        // Setup AVOSCloud
        AVOSCloud.setApplicationId("sP1qfVdFjg7uN3L9IvKqK3xT-gzGzoHsz", clientKey: "XhuPONcLKvAjdDVpeF9jst3j")
                
        // 分享平台设置
        ShareManager.setupShareSDK()
        
        // 设置样式
        setupAppearance()
        
        // 讯飞语音配置
        //setupFlySpeech()
        
        // 百度语音配置
        SpeechSynthesizerManager.sharedInstance.setupBDSpeech()
        let hasLaunched = UserDefaults.standard.bool(forKey: NGPHasLaunchedKey)
        
        if !hasLaunched {
            UserDefaults.standard.set(true, forKey: NGPHasLaunchedKey)
            SpeechSynthesizerManager.sharedInstance.speak(sentence: "您好，欢迎使用世界地理画报，可以通过摇一摇开启或关闭语音朗读")
        }
        
        setupUserNotification()
        
        IQKeyboardManager.sharedManager().enable = true
        
        // 处理本地通知
        if let localNotification = launchOptions?[.localNotification] as? UILocalNotification {
            if localNotification.userInfo?["identifier"] as? String == TodayWallpaperLocalNotificationIdentifier {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: {
                    self.showTodayWallpaper()
                })
            }
        }
        
        return true
    }
    
    func setupUserNotification() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if granted {
                    // 用户允许通知
                    self.createEverydayNotification()
                }
            }
        } else if #available(iOS 8.0, *) {
            // Fallback on earlier versions
            let settings = UIUserNotificationSettings(types: [.alert, .sound, .badge], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        createEverydayNotification()
    }
    
    func createEverydayNotification() {
        // 创建通知
        if #available(iOS 10.0, *) {
            
            // 1. 创建通知内容
            let content = UNMutableNotificationContent()
            content.title = "每日壁纸"
            content.body = "今日壁纸已经为您准备好！"
            
            // 2. 创建发送触发
            let dateComponents = DateComponents(hour: 10)
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
        else {
            
            if let localNotifications = UIApplication.shared.scheduledLocalNotifications {
                for local in localNotifications {
                    if local.userInfo?["identifier"] as? String == TodayWallpaperLocalNotificationIdentifier {
                        return
                    }
                }
            }

            UIApplication.shared.cancelAllLocalNotifications()
            
            let localNotify = UILocalNotification()
            
            let components = DateComponents(calendar: Calendar.current, hour: 10)
            if let fireDate = components.date {
                print(fireDate)
                localNotify.fireDate = fireDate
            }
            
            localNotify.repeatInterval = .day
            localNotify.applicationIconBadgeNumber += 1
            localNotify.alertBody = "今日壁纸已经为您准备好！"
            localNotify.alertAction = "打开"
            localNotify.hasAction = true
            localNotify.userInfo = ["identifier": TodayWallpaperLocalNotificationIdentifier]
            UIApplication.shared.scheduleLocalNotification(localNotify)
        }
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        
        showTodayWallpaper()
        application.applicationIconBadgeNumber -= 1
        
    }
    
    // MARK: - UNUserNotificationCenterDelegate
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == TodayWallpaperLocalNotificationIdentifier {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: { 
                self.showTodayWallpaper()
            })
        }
        completionHandler()
    }
    
    func setupAppearance() {
        UIApplication.shared.statusBarStyle = .lightContent
        UITabBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.systemFont(ofSize: 20)]
    }
    
    func showTodayWallpaper() {
        if let currentVC = UIApplication.currentViewController as? TodayPictorialPageViewController {
            currentVC.requestTodayPictorial()
        }
        else {
            DispatchQueue.main.async {
                let todayWallpaperVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TodayPictorialPageViewController")
                UIApplication.currentViewController?.present(todayWallpaperVC, animated: true, completion: nil)
            }
        }
    }
    
    func showTodayGeographic() {
        
        let initDate = NSDate(year: 2013, month: 1, day: 17)!
        let days = initDate.daysAgo()
        
        if days < 178 {
            return
        }
        
        if let currentVC = UIApplication.currentViewController as? AlbumDetailViewController {
            currentVC.albumID = String(days)
            currentVC.requestAlbumDetail()
        }
        else {
            let todayGeographicVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AlbumDetailViewController") as! AlbumDetailViewController
            todayGeographicVC.albumID = String(days)
            UIApplication.currentViewController?.present(todayGeographicVC, animated: true, completion: nil)
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.scheme == "ngp" && url.host == "TodayWallpaper" {
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
        try? audioSession.setCategory(AVAudioSessionCategoryPlayback)
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
            self.showTodayGeographic()
        }
        
        if shortcutItem.type == "TodayWallpaper" {
            self.showTodayWallpaper()
        }
    }
}

extension UIWindow {
    open override var canBecomeFirstResponder: Bool {
        return true
    }
    
    open override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        
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

