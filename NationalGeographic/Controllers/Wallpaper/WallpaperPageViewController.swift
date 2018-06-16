//
//  WallpaperPageViewController.swift
//  NationalGeographic
//
//  Created by Chaosky on 2016/11/20.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit

class WallpaperPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var selectedIndex = 0
    var wallpaperModelArray: [UnsplashModel]!
    
    var indexChanged: ((_ index: Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.dataSource = self
        self.delegate = self
        
        let initDetailVC = createWallpaperDetail()
        initDetailVC.wallpaperModel = wallpaperModelArray[selectedIndex]
        
        self.setViewControllers([initDetailVC], direction: .forward, animated: true, completion: nil)
        
        let tapGesture = UITapGestureRecognizer { (gesture) in
            self.dismiss(animated: true, completion: nil)
        }
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createWallpaperDetail() -> WallpaperDetailViewController {
        
        let wallpaperDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WallpaperDetailViewController") as! WallpaperDetailViewController
        return wallpaperDetailVC
    }
    
    func nextWallpaperDetail(for viewController: WallpaperDetailViewController, before: Bool) -> WallpaperDetailViewController? {
        if let index = wallpaperModelArray.index(of: viewController.wallpaperModel!) {
            let nextIndex = before ? index - 1 : index + 1
            if nextIndex < 0 || nextIndex >= wallpaperModelArray.count {
                return nil
            }
            else {
                let detailVC = self.createWallpaperDetail()
                detailVC.wallpaperModel = wallpaperModelArray[nextIndex]
                return detailVC
            }
        }
        else {
            return nil
        }
    }

    
    // MARK: - UIPageViewControllerDataSource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nextWallpaperDetail(for: viewController as! WallpaperDetailViewController, before: true)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nextWallpaperDetail(for: viewController as! WallpaperDetailViewController, before: false)
    }
    
    // MARK: - UIPageViewControllerDelegate
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let visiableVC = pageViewController.viewControllers?.first as? WallpaperDetailViewController {
            selectedIndex = wallpaperModelArray.index(of: visiableVC.wallpaperModel)!
            indexChanged?(selectedIndex)
        }
    }

}
