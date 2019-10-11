//
//  WallpaperDetailViewController.swift
//  WorldPicture
//
//  Created by Chaosky on 2016/11/20.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit
import Kingfisher
import MBProgressHUD

class WallpaperDetailViewController: UIViewController {
    
    var wallpaperModel: UnsplashModel!

    @IBOutlet weak var scrollView: UIScrollView!
    
    let imageView = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViews()
    }
    
    func setupViews() {
        
        self.scrollView.bounces = false
        
        self.scrollView.addSubview(imageView)
        imageView.frame = self.view.bounds
        imageView.contentMode = .scaleAspectFit
        
        if let url = wallpaperModel.full_url {
            imageView.kf.setImage(with: URL(string: url), placeholder: Asset.Assets.unsplashLoading.image, options: [.transition(.fade(0.5))], completionHandler: { (image, error, cacheType, url) in
                guard let img = image else {
                    return
                }
                
                let screenBounds = UIScreen.main.bounds
                let imageHeight = screenBounds.height
                var imageWidth = (img.size.width / img.size.height) * imageHeight
                imageWidth = fmax(imageWidth, screenBounds.width)
                self.imageView.frame = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
                
                self.scrollView.contentSize = CGSize(width: imageWidth, height: imageHeight)
                
                let offsetX = (imageWidth - screenBounds.width) / 2
                self.scrollView.contentOffset = CGPoint(x: offsetX, y: 0)
                
                self.view.layoutIfNeeded()
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveImageTapped(_ sender: UIButton) {
        if let saveImage = imageView.image {
            Utils.writeImageToPhotosAlbum(saveImage)
        }
    }
}
