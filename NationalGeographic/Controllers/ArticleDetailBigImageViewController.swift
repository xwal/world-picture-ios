//
//  ArticleDetailBigImageViewController.swift
//  NationalGeographic
//
//  Created by Chaosky on 2017/2/4.
//  Copyright © 2017年 ChaosVoid. All rights reserved.
//

import UIKit
import Kingfisher
import MBProgressHUD

class ArticleDetailBigImageViewController: UIViewController {

    @IBOutlet weak var bigImageView: UIImageView!
    
    var imageWebURL: URL?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bigImageView.contentMode = .scaleAspectFill
        bigImageView.kf.setImage(with: imageWebURL)
        bigImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer { (gesture) in
            self.dismiss(animated: true, completion: nil)
        }
        bigImageView.addGestureRecognizer(tapGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func download(_ sender: UIButton) {
        if let saveImage = bigImageView.image {
            UIImageWriteToSavedPhotosAlbum(saveImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeMutableRawPointer) {
        if error == nil {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.mode = .text
            hud.label.text = "已保存至相册"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                hud.hide(animated: true)
            })
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
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}
