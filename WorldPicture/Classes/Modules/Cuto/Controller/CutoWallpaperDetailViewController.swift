//
//  CutoWallpaperDetailViewController.swift
//  WorldPicture
//
//  Created by Chaosky on 2016/11/20.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit
import Kingfisher
import MBProgressHUD

class CutoWallpaperDetailViewController: UIViewController {
    
    var wallpaperModel: CutoWallpaperModel!

    @IBOutlet weak var scrollView: UIScrollView!
    
    let imageView = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViews()
    }
    
    func setupViews() {
        
        scrollView.bounces = false
        imageView.contentMode = .scaleAspectFit
        
        scrollView.addSubview(imageView)
        
        if let url = wallpaperModel.url {
            imageView.kf.setImage(with: URL(string: url), placeholder: Asset.Assets.unsplashLoading.image, options: [.transition(.fade(0.5))], completionHandler: { [weak self] handler in
                guard let self = self else { return }
                self.view.setNeedsLayout()
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let image = imageView.image else { return }
        let containerSize = scrollView.size
        let imageHeight = containerSize.height
        var imageWidth = (image.size.width / image.size.height) * imageHeight
        imageWidth = fmax(imageWidth, containerSize.width)
        imageView.frame = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
        
        scrollView.contentSize = CGSize(width: imageWidth, height: imageHeight)
        
        let offsetX = (imageWidth - containerSize.width) / 2
        scrollView.contentOffset = CGPoint(x: offsetX, y: 0)
    }
    
    @IBAction func saveImageTapped(_ sender: UIButton) {
        if let saveImage = imageView.image {
            Utils.writeImageToPhotosAlbum(saveImage)
        }
    }
}
