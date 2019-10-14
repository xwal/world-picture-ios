# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'
inhibit_all_warnings!

def public_pods
  pod 'RxSwift', :git => 'https://github.com/ReactiveX/RxSwift.git'
  pod 'RxCocoa', :git => 'https://github.com/ReactiveX/RxSwift.git'
  pod 'Alamofire'
  pod 'Kingfisher'
  pod 'Moya'
  pod 'SwiftyJSON'
  pod 'MJRefresh'
  pod 'YYModel'
  pod 'SwifterSwift'
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
  pod 'ObjectMapper'
end

def third_party_pods

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
    pod 'SnapKit'
end
