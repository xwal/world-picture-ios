// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

// swiftlint:disable sorted_imports
import Foundation
import UIKit

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Storyboard Scenes

// swiftlint:disable explicit_type_interface identifier_name line_length type_body_length type_name
internal enum StoryboardScene {
  internal enum Dili: StoryboardType {
    internal static let storyboardName = "Dili"

    internal static let initialScene = InitialSceneType<WorldPicture.CustomNavigationViewController>(storyboard: Dili.self)

    internal static let albumDetailViewController = SceneType<WorldPicture.DiliDetailViewController>(storyboard: Dili.self, identifier: "AlbumDetailViewController")

    internal static let diLiNavigationController = SceneType<WorldPicture.CustomNavigationViewController>(storyboard: Dili.self, identifier: "DiLiNavigationController")

    internal static let pictureDetailViewController = SceneType<WorldPicture.PictureDetailViewController>(storyboard: Dili.self, identifier: "PictureDetailViewController")
  }
  internal enum LaunchScreen: StoryboardType {
    internal static let storyboardName = "Launch Screen"

    internal static let initialScene = InitialSceneType<UIKit.UIViewController>(storyboard: LaunchScreen.self)
  }
  internal enum Main: StoryboardType {
    internal static let storyboardName = "Main"

    internal static let initialScene = InitialSceneType<WorldPicture.CustomTabBarViewController>(storyboard: Main.self)
  }
  internal enum NiceWallpaper: StoryboardType {
    internal static let storyboardName = "NiceWallpaper"

    internal static let initialScene = InitialSceneType<WorldPicture.CustomNavigationViewController>(storyboard: NiceWallpaper.self)

    internal static let niceWallpaperCategoryViewController = SceneType<WorldPicture.NiceWallpaperCategoryViewController>(storyboard: NiceWallpaper.self, identifier: "NiceWallpaperCategoryViewController")

    internal static let niceWallpaperDetailViewController = SceneType<WorldPicture.NiceWallpaperDetailViewController>(storyboard: NiceWallpaper.self, identifier: "NiceWallpaperDetailViewController")

    internal static let niceWallpaperNavigationController = SceneType<WorldPicture.CustomNavigationViewController>(storyboard: NiceWallpaper.self, identifier: "NiceWallpaperNavigationController")

    internal static let niceWallpaperViewController = SceneType<WorldPicture.NiceWallpaperViewController>(storyboard: NiceWallpaper.self, identifier: "NiceWallpaperViewController")
  }
  internal enum Pictorial: StoryboardType {
    internal static let storyboardName = "Pictorial"

    internal static let initialScene = InitialSceneType<WorldPicture.CustomNavigationViewController>(storyboard: Pictorial.self)

    internal static let articleDetailBigImageViewController = SceneType<WorldPicture.ArticleDetailBigImageViewController>(storyboard: Pictorial.self, identifier: "ArticleDetailBigImageViewController")

    internal static let articleDetailViewController = SceneType<WorldPicture.ArticleDetailViewController>(storyboard: Pictorial.self, identifier: "ArticleDetailViewController")

    internal static let pictorialUINavigationController = SceneType<WorldPicture.CustomNavigationViewController>(storyboard: Pictorial.self, identifier: "PictorialUINavigationController")

    internal static let todayPictorialPageViewController = SceneType<WorldPicture.TodayPictorialPageViewController>(storyboard: Pictorial.self, identifier: "TodayPictorialPageViewController")

    internal static let todayWallpaperViewController = SceneType<WorldPicture.TodayWallpaperViewController>(storyboard: Pictorial.self, identifier: "TodayWallpaperViewController")
  }
  internal enum Setting: StoryboardType {
    internal static let storyboardName = "Setting"

    internal static let initialScene = InitialSceneType<WorldPicture.CustomNavigationViewController>(storyboard: Setting.self)
  }
  internal enum Wallpaper: StoryboardType {
    internal static let storyboardName = "Wallpaper"

    internal static let initialScene = InitialSceneType<WorldPicture.CustomNavigationViewController>(storyboard: Wallpaper.self)

    internal static let wallpaperDetailViewController = SceneType<WorldPicture.WallpaperDetailViewController>(storyboard: Wallpaper.self, identifier: "WallpaperDetailViewController")

    internal static let wallpaperNavigationController = SceneType<WorldPicture.CustomNavigationViewController>(storyboard: Wallpaper.self, identifier: "WallpaperNavigationController")
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length type_body_length type_name

// MARK: - Implementation Details

internal protocol StoryboardType {
  static var storyboardName: String { get }
}

internal extension StoryboardType {
  static var storyboard: UIStoryboard {
    let name = self.storyboardName
    return UIStoryboard(name: name, bundle: Bundle(for: BundleToken.self))
  }
}

internal struct SceneType<T: UIViewController> {
  internal let storyboard: StoryboardType.Type
  internal let identifier: String

  internal func instantiate() -> T {
    let identifier = self.identifier
    guard let controller = storyboard.storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
      fatalError("ViewController '\(identifier)' is not of the expected class \(T.self).")
    }
    return controller
  }
}

internal struct InitialSceneType<T: UIViewController> {
  internal let storyboard: StoryboardType.Type

  internal func instantiate() -> T {
    guard let controller = storyboard.storyboard.instantiateInitialViewController() as? T else {
      fatalError("ViewController is not of the expected class \(T.self).")
    }
    return controller
  }
}

private final class BundleToken {}
