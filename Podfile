# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'
inhibit_all_warnings!

def public_pods
  pod 'Alamofire'
  pod 'Kingfisher'
  pod 'SwiftyJSON'
  pod 'MJRefresh'
  pod 'YYModel'
  pod 'YYCategories'
  pod 'MBProgressHUD'
  pod 'KVNProgress'
  pod 'SnapKit'
  pod 'LookinServer', :configurations => ['Debug']
  pod 'FLEX', :configurations => ['Debug']
  pod 'ZCAnimatedLabel'
  pod 'MMParallaxCell'
  pod 'IQKeyboardManagerSwift'
  pod 'Spring', :git => 'https://github.com/MengTo/Spring.git'
  pod 'M13Checkbox'
  pod 'DateToolsSwift'
  pod 'CHTCollectionViewWaterfallLayout'
  pod 'FDFullscreenPopGesture'
  pod 'DZNEmptyDataSet'
  pod 'SwiftyUserDefaults'
end

def third_party_pods
  # ShareSDK
  # 主模块(必须)
  pod 'mob_sharesdk'

  # UI模块(非必须，需要用到ShareSDK提供的分享菜单栏和分享编辑页面需要以下1行)
  pod 'mob_sharesdk/ShareSDKUI'

  # 平台SDK模块(对照一下平台，需要的加上。如果只需要QQ、微信、新浪微博，只需要以下3行)
  pod 'mob_sharesdk/ShareSDKPlatforms/QQ'
  pod 'mob_sharesdk/ShareSDKPlatforms/SinaWeibo'
  pod 'mob_sharesdk/ShareSDKPlatforms/WeChat'

  # 扩展模块（在调用可以弹出我们UI分享方法的时候是必需的）
  pod 'mob_sharesdk/ShareSDKExtension'

  # LeanCloud
  pod 'AVOSCloud', '~> 11.5'               # 数据存储、短信、云引擎调用等基础服务模块
  
  # Firebase
  pod 'Firebase/Analytics'
  pod 'Fabric'
  pod 'Crashlytics'
  pod 'Firebase/Performance'
  pod 'Firebase/AdMob'
  
  #---------------- Command Line Tool ---------------
  pod 'SwiftGen'
end

target 'WorldPicture' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for WorldPicture
  public_pods
  third_party_pods

end

target 'TodayWallpaperWidget' do
    use_frameworks!

    # Pods for WorldPicture
    pod 'Alamofire'
    pod 'Kingfisher'
    pod 'YYModel'
    pod 'YYCategories'
    pod 'SnapKit'
end
