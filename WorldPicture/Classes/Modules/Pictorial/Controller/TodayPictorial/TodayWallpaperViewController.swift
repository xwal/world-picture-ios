//
//  TodayWallpaperViewController.swift
//  WorldPicture
//
//  Created by Chaosky on 2016/12/2.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit
import Kingfisher
import MBProgressHUD

class TodayWallpaperViewController: UIViewController {

    @IBOutlet weak var wallpaperImageView: UIImageView!
    
    @IBOutlet weak var todayLabel: UILabel!
    
    @IBOutlet weak var monthLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var destinationLabel: UILabel!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var downloadButton: UIButton!
    
    var wallpapperModel: WallpaperModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViews()
    }
    
    func showOrHideView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.topView.alpha = self.topView.alpha == 0 ? 1 : 0
            self.bottomView.alpha = self.bottomView.alpha == 0 ? 1 : 0
            self.downloadButton.alpha = self.downloadButton.alpha == 0 ? 1 : 0
        })
    }
    
    func setupViews() {
        downloadButton.alpha = 0
        let tapGesture = UITapGestureRecognizer { (gesture) in
            self.showOrHideView()
        }
        self.view.addGestureRecognizer(tapGesture)
        
        topView.layer.contents = Image(named: "Navbar_mask")?.cgImage
        bottomView.layer.contents = Image(named: "TopMask")?.cgImage
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        
        dateFormatter.dateFormat = "dd"
        let day = dateFormatter.string(from: Date())
        
        dateFormatter.dateFormat = "MMMM"
        let month = dateFormatter.string(from: Date())
        
        todayLabel.text = day
        monthLabel.text = month
        titleLabel.text = wallpapperModel.title
        destinationLabel.text = "每日壁纸 — \(wallpapperModel.destination ?? "")"
        
        if let imageURL = wallpapperModel.ios_wallpaper_url {
            wallpaperImageView.kf.setImage(with: URL(string: imageURL), options: [.transition(.fade(0.5))])
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func downloadTapped(_ sender: UIButton) {
        
        if let saveImage = wallpaperImageView.image {
            Utils.writeImageToPhotosAlbum(saveImage)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
