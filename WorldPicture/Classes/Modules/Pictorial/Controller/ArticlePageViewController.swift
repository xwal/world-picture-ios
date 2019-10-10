//
//  ArticlePageViewController.swift
//  WorldPicture
//
//  Created by Chaosky on 2016/11/21.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit

class ArticlePageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var selectedIndex = 0
    var articleModelArray = [PictorialArticleModel]()
    
    let progressView = UIProgressView(progressViewStyle: .default)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.dataSource = self
        self.delegate = self
        
        let initDetailVC = createArticleDetail()
        initDetailVC.articleModel = articleModelArray[selectedIndex]
        
        self.setViewControllers([initDetailVC], direction: .forward, animated: false, completion: nil)
        
        let tapGesture = UITapGestureRecognizer { (gesture) in
            self.dismiss(animated: true, completion: nil)
        }
        self.view.addGestureRecognizer(tapGesture)
        
        progressView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 5)
        self.view.addSubview(progressView)
        
        progressView.progress = Float(selectedIndex + 1) / Float(articleModelArray.count)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createArticleDetail() -> ArticleDetailViewController {
        
        let articleDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ArticleDetailViewController") as! ArticleDetailViewController
        return articleDetailVC
    }
    
    func nextArticleDetail(for viewController: ArticleDetailViewController, before: Bool) -> ArticleDetailViewController? {
        if let index = articleModelArray.index(of: viewController.articleModel) {
            let nextIndex = before ? index - 1 : index + 1
            if nextIndex < 0 || nextIndex >= articleModelArray.count {
                return nil
            }
            else {
                let detailVC = self.createArticleDetail()
                detailVC.articleModel = articleModelArray[nextIndex]
                return detailVC
            }
        }
        else {
            return nil
        }
    }
    
    
    // MARK: - UIPageViewControllerDataSource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nextArticleDetail(for: viewController as! ArticleDetailViewController, before: true)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nextArticleDetail(for: viewController as! ArticleDetailViewController, before: false)
    }
    
    // MARK: - UIPageViewControllerDelegate
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let visiableVC = pageViewController.viewControllers?.first as? ArticleDetailViewController {
            selectedIndex = articleModelArray.index(of: visiableVC.articleModel)!
            progressView.setProgress(Float(selectedIndex + 1) / Float(articleModelArray.count), animated: true)
        }
    }

}
