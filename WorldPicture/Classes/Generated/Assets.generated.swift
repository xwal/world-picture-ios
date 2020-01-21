// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSImage
  internal typealias AssetColorTypeAlias = NSColor
  internal typealias AssetImageTypeAlias = NSImage
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIImage
  internal typealias AssetColorTypeAlias = UIColor
  internal typealias AssetImageTypeAlias = UIImage
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal enum Assets {
    internal static let defaultIcon = ImageAsset(name: "DefaultIcon")
    internal static let launchIcon = ImageAsset(name: "LaunchIcon")
    internal static let dropdownAnim00 = ImageAsset(name: "dropdown_anim_00")
    internal static let dropdownAnim01 = ImageAsset(name: "dropdown_anim_01")
    internal static let dropdownAnim02 = ImageAsset(name: "dropdown_anim_02")
    internal static let dropdownAnim03 = ImageAsset(name: "dropdown_anim_03")
    internal static let dropdownAnim04 = ImageAsset(name: "dropdown_anim_04")
    internal static let placeholderEmptydataset = ImageAsset(name: "placeholder_emptydataset")
    internal static let unsplashDefault = ImageAsset(name: "unsplash_default")
    internal static let unsplashLoading = ImageAsset(name: "unsplash_loading")
  }
  internal enum NiceWallpaper {
    internal static let iconAppStore = ImageAsset(name: "icon_app_store")
    internal static let iconCamera = ImageAsset(name: "icon_camera")
    internal static let iconCategory = ImageAsset(name: "icon_category")
    internal static let iconCollectionviewNormal = ImageAsset(name: "icon_collectionview_normal")
    internal static let iconCollectionviewPressed = ImageAsset(name: "icon_collectionview_pressed")
    internal static let iconMail = ImageAsset(name: "icon_mail")
    internal static let iconMessages = ImageAsset(name: "icon_messages")
    internal static let iconMusic = ImageAsset(name: "icon_music")
    internal static let iconPhones = ImageAsset(name: "icon_phones")
    internal static let iconPhotos = ImageAsset(name: "icon_photos")
    internal static let iconSafari = ImageAsset(name: "icon_safari")
    internal static let iconSave = ImageAsset(name: "icon_save")
    internal static let iconSettings = ImageAsset(name: "icon_settings")
    internal static let iconWeather = ImageAsset(name: "icon_weather")
    internal static let imageviewShadow = ImageAsset(name: "imageview_shadow")
    internal static let listIconFlower = ImageAsset(name: "list_icon_flower")
    internal static let listIconFlowerPressed = ImageAsset(name: "list_icon_flower_pressed")
    internal static let personalHeadDefault = ImageAsset(name: "personal_head_default")
    internal static let personalPicDefault = ImageAsset(name: "personal_pic_default")
    internal static let picShadow = ImageAsset(name: "pic_shadow")
    internal static let picShadowLeft = ImageAsset(name: "pic_shadow_left")
    internal static let picShadowPerson = ImageAsset(name: "pic_shadow_person")
    internal static let picShadowRight = ImageAsset(name: "pic_shadow_right")
    internal static let shareBgNormal = ImageAsset(name: "share_bg_normal")
    internal static let shareBgPressed = ImageAsset(name: "share_bg_pressed")
    internal static let shareMoreNormal = ImageAsset(name: "share_more_normal")
    internal static let shareMorePressed = ImageAsset(name: "share_more_pressed")
  }
  internal enum Pictorial {
    internal static let buttonBackNormal = ImageAsset(name: "ButtonBack_normal")
    internal static let buttonBackPressed = ImageAsset(name: "ButtonBack_pressed")
    internal static let buttonDownloadBigNormal = ImageAsset(name: "ButtonDownloadBig_normal")
    internal static let buttonDownloadBigPressed = ImageAsset(name: "ButtonDownloadBig_pressed")
    internal static let navbarMask = ImageAsset(name: "Navbar_mask")
    internal static let placeholder = ImageAsset(name: "Placeholder")
    internal static let settingClean = ImageAsset(name: "SettingClean")
    internal static let settingCommend = ImageAsset(name: "SettingCommend")
    internal static let settingComment = ImageAsset(name: "SettingComment")
    internal static let settingFeedback = ImageAsset(name: "SettingFeedback")
    internal static let titleSeparator = ImageAsset(name: "TitleSeparator")
    internal static let toolbarLikeNormal = ImageAsset(name: "ToolbarLike_normal")
    internal static let toolbarLikePressed = ImageAsset(name: "ToolbarLike_pressed")
    internal static let toolbarNationalNormal = ImageAsset(name: "ToolbarNational_normal")
    internal static let toolbarNationalPressed = ImageAsset(name: "ToolbarNational_pressed")
    internal static let toolbarPictorialNormal = ImageAsset(name: "ToolbarPictorial_normal")
    internal static let toolbarPictorialPressed = ImageAsset(name: "ToolbarPictorial_pressed")
    internal static let toolbarSettingNormal = ImageAsset(name: "ToolbarSetting_normal")
    internal static let toolbarSettingPressed = ImageAsset(name: "ToolbarSetting_pressed")
    internal static let toolbarWallpaperNormal = ImageAsset(name: "ToolbarWallpaper_normal")
    internal static let toolbarWallpaperPressed = ImageAsset(name: "ToolbarWallpaper_pressed")
    internal static let topMask = ImageAsset(name: "TopMask")
  }
  internal enum Unsplash {
    internal static let button1password = ImageAsset(name: "button-1password")
    internal static let buttonAction = ImageAsset(name: "button-action")
    internal static let buttonClose = ImageAsset(name: "button-close")
    internal static let buttonCollect = ImageAsset(name: "button-collect")
    internal static let buttonCollected = ImageAsset(name: "button-collected")
    internal static let buttonCross = ImageAsset(name: "button-cross")
    internal static let buttonDownload = ImageAsset(name: "button-download")
    internal static let buttonInfo = ImageAsset(name: "button-info")
    internal static let buttonLike = ImageAsset(name: "button-like")
    internal static let buttonStats = ImageAsset(name: "button-stats")
    internal static let buttonSubmitPlus = ImageAsset(name: "button-submit-plus")
    internal static let buttonUser = ImageAsset(name: "button-user")
    internal static let dismissCross = ImageAsset(name: "dismiss-cross")
    internal static let downloadArrow = ImageAsset(name: "download-arrow")
    internal static let iconAddToCollection = ImageAsset(name: "icon-add-to-collection")
    internal static let iconCollected = ImageAsset(name: "icon-collected")
    internal static let iconLocation = ImageAsset(name: "icon-location")
    internal static let iconLock = ImageAsset(name: "icon-lock")
    internal static let iconUrl = ImageAsset(name: "icon-url")
    internal static let locationPin = ImageAsset(name: "location-pin")
    internal static let more = ImageAsset(name: "more")
    internal static let onboardingPhoto0 = ImageAsset(name: "onboarding-photo-0")
    internal static let onboardingPhoto1 = ImageAsset(name: "onboarding-photo-1")
    internal static let onboardingPhoto10 = ImageAsset(name: "onboarding-photo-10")
    internal static let onboardingPhoto11 = ImageAsset(name: "onboarding-photo-11")
    internal static let onboardingPhoto12 = ImageAsset(name: "onboarding-photo-12")
    internal static let onboardingPhoto13 = ImageAsset(name: "onboarding-photo-13")
    internal static let onboardingPhoto14 = ImageAsset(name: "onboarding-photo-14")
    internal static let onboardingPhoto15 = ImageAsset(name: "onboarding-photo-15")
    internal static let onboardingPhoto16 = ImageAsset(name: "onboarding-photo-16")
    internal static let onboardingPhoto17 = ImageAsset(name: "onboarding-photo-17")
    internal static let onboardingPhoto18 = ImageAsset(name: "onboarding-photo-18")
    internal static let onboardingPhoto19 = ImageAsset(name: "onboarding-photo-19")
    internal static let onboardingPhoto2 = ImageAsset(name: "onboarding-photo-2")
    internal static let onboardingPhoto20 = ImageAsset(name: "onboarding-photo-20")
    internal static let onboardingPhoto21 = ImageAsset(name: "onboarding-photo-21")
    internal static let onboardingPhoto3 = ImageAsset(name: "onboarding-photo-3")
    internal static let onboardingPhoto4 = ImageAsset(name: "onboarding-photo-4")
    internal static let onboardingPhoto5 = ImageAsset(name: "onboarding-photo-5")
    internal static let onboardingPhoto6 = ImageAsset(name: "onboarding-photo-6")
    internal static let onboardingPhoto7 = ImageAsset(name: "onboarding-photo-7")
    internal static let onboardingPhoto8 = ImageAsset(name: "onboarding-photo-8")
    internal static let onboardingPhoto9 = ImageAsset(name: "onboarding-photo-9")
    internal static let panelChevron = ImageAsset(name: "panel-chevron")
    internal static let placeholderNoCollections = ImageAsset(name: "placeholder-no-collections")
    internal static let placeholderNoLikes = ImageAsset(name: "placeholder-no-likes")
    internal static let placeholderNoPhotos = ImageAsset(name: "placeholder-no-photos")
    internal static let search = ImageAsset(name: "search")
    internal static let trash = ImageAsset(name: "trash")
    internal static let unsplashLogo = ImageAsset(name: "unsplash-logo")
  }
  internal enum Dili {
    internal static let bjbj = ImageAsset(name: "bjbj")
    internal static let cancel = ImageAsset(name: "cancel")
    internal static let lidown = ImageAsset(name: "lidown")
    internal static let linor = ImageAsset(name: "linor")
    internal static let newbj = ImageAsset(name: "newbj")
    internal static let nopic = ImageAsset(name: "nopic")
    internal static let phoneEye = ImageAsset(name: "phone-eye")
    internal static let phone1SaveDown = ImageAsset(name: "phone1-save-down")
    internal static let phone1SaveNor = ImageAsset(name: "phone1-save-nor")
    internal static let phone1ShareDown = ImageAsset(name: "phone1-share-down")
    internal static let phone1ShareNor = ImageAsset(name: "phone1-share-nor")
    internal static let phone2SaveDown = ImageAsset(name: "phone2-save-down")
    internal static let phone2SaveNor = ImageAsset(name: "phone2-save-nor")
    internal static let phone2ShareDown = ImageAsset(name: "phone2-share-down")
    internal static let phone2ShareNor = ImageAsset(name: "phone2-share-nor")
    internal static let x = ImageAsset(name: "x")
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal struct ColorAsset {
  internal fileprivate(set) var name: String

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  internal var color: AssetColorTypeAlias {
    return AssetColorTypeAlias(asset: self)
  }
}

internal extension AssetColorTypeAlias {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  convenience init!(asset: ColorAsset) {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

internal struct DataAsset {
  internal fileprivate(set) var name: String

  #if os(iOS) || os(tvOS) || os(OSX)
  @available(iOS 9.0, tvOS 9.0, OSX 10.11, *)
  internal var data: NSDataAsset {
    return NSDataAsset(asset: self)
  }
  #endif
}

#if os(iOS) || os(tvOS) || os(OSX)
@available(iOS 9.0, tvOS 9.0, OSX 10.11, *)
internal extension NSDataAsset {
  convenience init!(asset: DataAsset) {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    self.init(name: asset.name, bundle: bundle)
    #elseif os(OSX)
    self.init(name: NSDataAsset.Name(asset.name), bundle: bundle)
    #endif
  }
}
#endif

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  internal var image: AssetImageTypeAlias {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    let image = AssetImageTypeAlias(named: name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    let image = bundle.image(forResource: NSImage.Name(name))
    #elseif os(watchOS)
    let image = AssetImageTypeAlias(named: name)
    #endif
    guard let result = image else { fatalError("Unable to load image named \(name).") }
    return result
  }
}

internal extension AssetImageTypeAlias {
  @available(iOS 1.0, tvOS 1.0, watchOS 1.0, *)
  @available(OSX, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init!(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = Bundle(for: BundleToken.self)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

private final class BundleToken {}
