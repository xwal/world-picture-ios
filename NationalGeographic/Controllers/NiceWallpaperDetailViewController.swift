//
//  NiceWallpaperDetailViewController.swift
//  NationalGeographic
//
//  Created by Chaosky on 2016/12/13.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit
import CoreMotion
import ZCAnimatedLabel
import SnapKit

class NiceWallpaperDetailViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var monthLabel: UILabel!
    
    @IBOutlet weak var weekLabel: UILabel!
    
    @IBOutlet weak var descDashLabel: ZCAnimatedLabel!
    
    let motionManager = CMMotionManager()
    var imageModel: NiceWallpaperImageModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupViews()
        setupCoreMotion()
    }
    
    func setupCoreMotion() {
        if motionManager.isDeviceMotionAvailable {
            // 采样率
            motionManager.deviceMotionUpdateInterval = 1 / 60.0
            // 采样
            motionManager.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: { (deviceMotion, error) in
                if error != nil {
                    return
                }
                guard let attitude = deviceMotion?.attitude else {
                    return
                }
                self.scrollRoll(rate: attitude.roll)
            })
        }
    }
    
    func setupViews() {
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        self.scrollView.bounces = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.isScrollEnabled = false
        
        let imageHeight = UIScreen.screenSize.height
        var imageWidth = (imageModel.width / imageModel.height) * imageHeight
        imageWidth = imageWidth > UIScreen.screenSize.width ? imageWidth : UIScreen.screenSize.width
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight))
        imageView.contentMode = .scaleAspectFill
        self.scrollView.addSubview(imageView)
        self.scrollView.contentSize = CGSize(width: imageWidth, height: imageHeight)
        imageView.kf.setImage(with: URL(string: "\(niceWallpaperImageBaseURL)\(imageModel.image_url ?? "")"))
        
        let offsetX = (imageWidth - UIScreen.screenSize.width) / 2
        self.scrollView.contentOffset = CGPoint(x: offsetX, y: 0)
        
        descDashLabel.text = imageModel.desc
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        style.alignment = .left
        style.minimumLineHeight = 18
        let attrString = NSAttributedString(string: descDashLabel.text, attributes: [NSParagraphStyleAttributeName: style,  NSFontAttributeName: UIFont.systemFont(ofSize: 16), NSForegroundColorAttributeName: UIColor.white])
        
        descDashLabel.attributedString = attrString
        
        self.view.layoutIfNeeded()
        self.descDashLabel.sizeToFit()
        self.descDashLabel.startAppearAnimation()
        
        guard let pubTime = imageModel.pub_time else {
            return
        }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en")
        formatter.dateFormat = "dd,MMM,EEEE"
        
        let formatDateStr = formatter.string(from: pubTime)
        let dateArray = formatDateStr.components(separatedBy: ",")
        dayLabel.text = dateArray[0]
        monthLabel.text = dateArray[1]
        weekLabel.text = dateArray[2]
    }
    
    func scrollRoll(rate: Double) {
        var contentOffset = self.scrollView.contentOffset
        
        let rightX = self.scrollView.contentSize.width - UIScreen.screenSize.width
        
        if rate < -0.2 {
            contentOffset.x -= CGFloat(rate * 10)
        }
        else if rate > 0.2 {
            contentOffset.x -= CGFloat(rate * 10)
        }
        
        if contentOffset.x <= 0 {
            contentOffset.x = 0
        }
        
        if contentOffset.x >= rightX  {
            contentOffset.x = rightX
        }
        
        self.scrollView.contentOffset = contentOffset
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
