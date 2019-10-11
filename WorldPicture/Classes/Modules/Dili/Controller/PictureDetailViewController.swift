//
//  PictureDetailViewController.swift
//  WorldPicture
//
//  Created by Chaosky on 2016/11/20.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit
import Kingfisher

class PictureDetailViewController: UIViewController, UIScrollViewDelegate {
    
    var pictureModel: PictureModel!

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let url = pictureModel.thumb {
            imageView.kf.setImage(with: URL(string: url), placeholder: Image(named: "nopic"), options: [.transition(.fade(0.5))])
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        tapGesture.numberOfTapsRequired = 2
        self.scrollView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func onTap() {
        self.scrollView.zoomScale = self.scrollView.zoomScale == 1 ? 2 : 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollView.zoomScale = 1
        self.view.layoutIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 转屏处理
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (context) in
            print("转屏前调用")
        }) { (context) in
            print("转屏后调用")
        }
        UIView.animate(withDuration: coordinator.transitionDuration) { 
            self.scrollView.zoomScale = 1
            self.view.layoutIfNeeded()
        }
        super.viewWillTransition(to: size, with: coordinator)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    // MARK: - UIScrollViewDelegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView.superview
    }

}
