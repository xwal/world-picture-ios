//
//  NiceWallpaperPageViewController.swift
//  WorldPicture
//
//  Created by Chaosky on 2017/2/9.
//  Copyright © 2017年 ChaosVoid. All rights reserved.
//

import UIKit

class NiceWallpaperPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var wpEverydayVC: NiceWallpaperViewController!
    var wpCategoryVC: NiceWallpaperCategoryViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViewController()
    }
    
    func setupViewController() {
        
        dataSource = self
        delegate = self
        
        wpEverydayVC = StoryboardScene.NiceWallpaper.niceWallpaperViewController.instantiate()
        wpCategoryVC = StoryboardScene.NiceWallpaper.niceWallpaperCategoryViewController.instantiate()
        
        setViewControllers([wpEverydayVC], direction: .forward, animated: false, completion: nil)
        navigationItem.title = "每日最美"
        
        let leftButton = UIButton(type: .custom)
        leftButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        leftButton.tintColor = UIColor.clear
        leftButton.setImage(Asset.NiceWallpaper.iconCategory.image, for: .normal)
        leftButton.addTarget(self, action: #selector(clickCategoryButton(sender:)), for: .touchUpInside)
        
        let leftBarItem = UIBarButtonItem(customView: leftButton)
        navigationItem.leftBarButtonItem = leftBarItem
    }
    
    @objc func clickCategoryButton(sender: UIButton) {
        
        guard let vc = viewControllers?.first else {
            return
        }
        
        if vc == wpEverydayVC {
            setViewControllers([wpCategoryVC], direction: .reverse, animated: true, completion: nil)
            navigationItem.title = "分类"
        }
        else {
            setViewControllers([wpEverydayVC], direction: .forward, animated: true, completion: nil)
            navigationItem.title = "每日最美"
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    // MARK: - UIPageViewControllerDataSource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return viewController == wpEverydayVC ? wpCategoryVC : nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return viewController == wpEverydayVC ? nil : wpEverydayVC
    }
    
    // MARK: - UIPageViewControllerDelegate
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let vc = pageViewController.viewControllers?.first {
            if vc == wpEverydayVC {
                navigationItem.title = "每日最美"
            }
            else {
                navigationItem.title = "分类"
            }
        }
    }

}
