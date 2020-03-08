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
    internal enum Common {
      internal static let defaultIcon = ImageAsset(name: "Common/DefaultIcon")
      internal static let dropdownAnim00 = ImageAsset(name: "Common/dropdown_anim_00")
      internal static let dropdownAnim01 = ImageAsset(name: "Common/dropdown_anim_01")
      internal static let dropdownAnim02 = ImageAsset(name: "Common/dropdown_anim_02")
      internal static let dropdownAnim03 = ImageAsset(name: "Common/dropdown_anim_03")
      internal static let dropdownAnim04 = ImageAsset(name: "Common/dropdown_anim_04")
      internal static let unsplashDefault = ImageAsset(name: "Common/unsplash_default")
      internal static let unsplashLoading = ImageAsset(name: "Common/unsplash_loading")
    }
    internal enum Dili {
      internal static let download = ImageAsset(name: "Dili/download")
      internal static let nopic = ImageAsset(name: "Dili/nopic")
      internal static let share = ImageAsset(name: "Dili/share")
      internal static let x = ImageAsset(name: "Dili/x")
    }
    internal enum Pictorial {
      internal static let buttonBackNormal = ImageAsset(name: "Pictorial/ButtonBack_normal")
      internal static let buttonDownloadBigNormal = ImageAsset(name: "Pictorial/ButtonDownloadBig_normal")
      internal static let navbarMask = ImageAsset(name: "Pictorial/Navbar_mask")
      internal static let titleSeparator = ImageAsset(name: "Pictorial/TitleSeparator")
    }
    internal enum TabBar {
      internal static let toolbarLikeNormal = ImageAsset(name: "TabBar/ToolbarLike_normal")
      internal static let toolbarLikePressed = ImageAsset(name: "TabBar/ToolbarLike_pressed")
      internal static let toolbarNationalNormal = ImageAsset(name: "TabBar/ToolbarNational_normal")
      internal static let toolbarNationalPressed = ImageAsset(name: "TabBar/ToolbarNational_pressed")
      internal static let toolbarPictorialNormal = ImageAsset(name: "TabBar/ToolbarPictorial_normal")
      internal static let toolbarPictorialPressed = ImageAsset(name: "TabBar/ToolbarPictorial_pressed")
      internal static let toolbarSettingNormal = ImageAsset(name: "TabBar/ToolbarSetting_normal")
      internal static let toolbarSettingPressed = ImageAsset(name: "TabBar/ToolbarSetting_pressed")
      internal static let toolbarWallpaperNormal = ImageAsset(name: "TabBar/ToolbarWallpaper_normal")
      internal static let toolbarWallpaperPressed = ImageAsset(name: "TabBar/ToolbarWallpaper_pressed")
    }
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
