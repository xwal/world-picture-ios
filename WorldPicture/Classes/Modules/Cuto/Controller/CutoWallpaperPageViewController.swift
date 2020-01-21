//
//  CutoWallpaperPageViewController.swift
//  WorldPicture
//
//  Created by Chaosky on 2016/11/20.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit

class CutoWallpaperPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var selectedIndex = 0
    var wallpaperModelArray: [CutoWallpaperModel]!
    
    var indexChanged: ((_ index: Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dataSource = self
        delegate = self
        
        let initDetailVC = createWallpaperDetail()
        initDetailVC.wallpaperModel = wallpaperModelArray[selectedIndex]
        
        setViewControllers([initDetailVC], direction: .forward, animated: true, completion: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createWallpaperDetail() -> CutoWallpaperDetailViewController {
        
        let wallpaperDetailVC = StoryboardScene.CutoWallpaper.wallpaperDetailViewController.instantiate()
        return wallpaperDetailVC
    }
    
    func nextWallpaperDetail(for viewController: CutoWallpaperDetailViewController, before: Bool) -> CutoWallpaperDetailViewController? {
        if let index = wallpaperModelArray.firstIndex(of: viewController.wallpaperModel!) {
            let nextIndex = before ? index - 1 : index + 1
            if nextIndex < 0 || nextIndex >= wallpaperModelArray.count {
                return nil
            }
            else {
                let detailVC = createWallpaperDetail()
                detailVC.wallpaperModel = wallpaperModelArray[nextIndex]
                return detailVC
            }
        }
        else {
            return nil
        }
    }
    
    @objc private func onTap() {
        dismiss(animated: true, completion: nil)
    }

    
    // MARK: - UIPageViewControllerDataSource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nextWallpaperDetail(for: viewController as! CutoWallpaperDetailViewController, before: true)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nextWallpaperDetail(for: viewController as! CutoWallpaperDetailViewController, before: false)
    }
    
    // MARK: - UIPageViewControllerDelegate
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let visiableVC = pageViewController.viewControllers?.first as? CutoWallpaperDetailViewController {
            selectedIndex = wallpaperModelArray.firstIndex(of: visiableVC.wallpaperModel)!
            indexChanged?(selectedIndex)
        }
    }

}
