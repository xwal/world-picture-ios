//
//  WallpaperPageViewController.swift
//  NationalGeographic
//
//  Created by Chaosky on 2016/11/20.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit

class WallpaperPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var wallpaperModelArray: [WallpaperModel]!
    var wallpaperDetailArray = [WallpaperDetailViewController]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.dataSource = self
        self.delegate = self
        
        let initDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "WallpaperDetailViewController") as! WallpaperDetailViewController
        initDetailVC.wallpaperModel = wallpaperModelArray[0]
        wallpaperDetailArray.append(initDetailVC)
        
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
    
    func nextViewController(_ viewController: WallpaperDetailViewController, before: Bool) -> WallpaperDetailViewController? {
        if let index = wallpaperModelArray.index(of: viewController.wallpaperModel!) {
            let nextIndex = before ? index - 1 : index + 1
            if nextIndex < 0 || nextIndex >= wallpaperModelArray.count {
                return nil
            }
            else {
                if nextIndex >= wallpaperDetailArray.count {
                    if let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "WallpaperDetailViewController") as? WallpaperDetailViewController {
                        detailVC.wallpaperModel = wallpaperModelArray[nextIndex]
                        wallpaperDetailArray.insert(detailVC, at: nextIndex)
                        return detailVC
                    }
                    return nil
                    
                }
                else {
                    let detailVC = wallpaperDetailArray[nextIndex]
                    return detailVC
                }
            }
        }
        else {
            return nil
        }
    }

    
    // MARK: - UIPageViewControllerDataSource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        return nextViewController(viewController as! WallpaperDetailViewController, before: true)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nextViewController(viewController as! WallpaperDetailViewController, before: false)
    }

}
