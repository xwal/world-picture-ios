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
import AVFoundation

class NiceWallpaperDetailViewController: UIViewController {
    
    enum WallpaperSwipeDrection : Int {
        case current
        case forward
        case reverse
    }

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var monthLabel: UILabel!
    
    @IBOutlet weak var weekLabel: UILabel!
    
    @IBOutlet weak var descDashLabel: ZCAnimatedLabel!
    
    private let wallpaperImageView = UIImageView()
    
    private let motionManager = CMMotionManager()
    var imageModelArray: [NiceWallpaperImageModel]!
    var currentIndex = 0
    
    private let speechSynthesizer = AVSpeechSynthesizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupViews()
        showNext(direction: .current)
        setupCoreMotion()
        
        let leftSwipGesture = UISwipeGestureRecognizer(target: self, action: #selector(onSwipChanged(sender:)))
        leftSwipGesture.direction = [.left]
        self.view.addGestureRecognizer(leftSwipGesture)
        
        let rightSwipGesture = UISwipeGestureRecognizer(target: self, action: #selector(onSwipChanged(sender:)))
        rightSwipGesture.direction = [.right]
        self.view.addGestureRecognizer(rightSwipGesture)
    }
    
    func onSwipChanged(sender: UISwipeGestureRecognizer) {
        
        if sender.direction == .left {
            showNext(direction: .forward)
        }
        else if sender.direction == .right {
            showNext(direction: .reverse)
        }
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
    
    func showNext(direction: WallpaperSwipeDrection) {
        
        switch direction {
        case .forward:
            if currentIndex + 1 < imageModelArray.count {
                currentIndex += 1
            }
            else {
                return
            }
        case .reverse:
            if currentIndex - 1 >= 0 {
                currentIndex -= 1
            }
            else {
                return
            }
        case .current:
            if !(0..<imageModelArray.count).contains(currentIndex) {
                return
            }
            
            break
        }
        
        let tempWallpaperModel = imageModelArray[currentIndex]
        
        let imageHeight = UIScreen.screenSize.height
        var imageWidth = (tempWallpaperModel.width / tempWallpaperModel.height) * imageHeight
        imageWidth = fmax(imageWidth, UIScreen.screenSize.width)
        wallpaperImageView.frame = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
        
        self.scrollView.contentSize = CGSize(width: imageWidth, height: imageHeight)
        wallpaperImageView.kf.setImage(with: URL(string: "\(niceWallpaperImageBaseURL)\(tempWallpaperModel.image_url ?? "")"), options: [.transition(.fade(1))])
        
        let offsetX = (imageWidth - UIScreen.screenSize.width) / 2
        self.scrollView.contentOffset = CGPoint(x: offsetX, y: 0)
        
        descDashLabel.stopAnimation()
        
        descDashLabel.text = tempWallpaperModel.desc
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        style.alignment = .left
        style.minimumLineHeight = 18
        let attrString = NSAttributedString(string: descDashLabel.text, attributes: [NSParagraphStyleAttributeName: style,  NSFontAttributeName: UIFont.systemFont(ofSize: 16), NSForegroundColorAttributeName: UIColor.white])
        
        descDashLabel.attributedString = attrString
        
        self.view.layoutIfNeeded()
        self.descDashLabel.sizeToFit()
        self.descDashLabel.startAppearAnimation()
        
        guard let pubTime = tempWallpaperModel.pub_time else {
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
        
        if view.layer.animation(forKey: "aniKey") == nil {
            let transition = CATransition()
            transition.type = kCATransitionFade
            transition.duration = 1
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            
            // This makes the animation go.
            self.view.layer.add(transition, forKey: "aniKey")
        }
        let utterance = AVSpeechUtterance(string: tempWallpaperModel.desc ?? "")
        speechSynthesizer.speak(utterance)
        
    }
    
    func setupViews() {
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        self.scrollView.bounces = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.isScrollEnabled = false
        
        self.scrollView.addSubview(wallpaperImageView)
        wallpaperImageView.contentMode = .scaleAspectFill
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
