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
import Spring
import CoreGraphics
import M13Checkbox
import MBProgressHUD

class NiceWallpaperDetailViewController: UIViewController {
    
    enum WallpaperSwipeDrection : Int {
        case current
        case forward
        case reverse
    }

    @IBOutlet weak var bottomView: SpringView!
    @IBOutlet weak var topView: SpringView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var snapshotImageView: SpringImageView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var descDashLabel: ZCAnimatedLabel!
    @IBOutlet weak var dateCheckbox: M13Checkbox!
    @IBOutlet weak var descCheckbox: M13Checkbox!
    @IBOutlet weak var backButton: UIButton!
    
    private let wallpaperImageView = UIImageView()
    
    private var snapshotImage: UIImage?
    
    private let motionManager = CMMotionManager()
    var imageModelArray: [NiceWallpaperImageModel]!
    var currentIndex = 0
    
    private let scalePercent: CGFloat = 0.9
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupViews()
        showNext(direction: .current)
        startDeviceMotion()
        
        let leftSwipGesture = UISwipeGestureRecognizer(target: self, action: #selector(onSwipChanged(sender:)))
        leftSwipGesture.direction = [.left]
        self.view.addGestureRecognizer(leftSwipGesture)
        
        let rightSwipGesture = UISwipeGestureRecognizer(target: self, action: #selector(onSwipChanged(sender:)))
        rightSwipGesture.direction = [.right]
        self.view.addGestureRecognizer(rightSwipGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onSnapshotTapped(sender:)))
        self.view.addGestureRecognizer(tapGesture)
        
        let bottomTapGesture = UITapGestureRecognizer(target: nil, action: nil)
        bottomView.addGestureRecognizer(bottomTapGesture)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SpeechSynthesizerManager.sharedInstance.cancel()
    }
    
    func onSnapshotTapped(sender: UITapGestureRecognizer) {
        if snapshotImageView.isHidden {
            snapshotImage = scrollView.createSnapshotImage()
            snapshotImageView.image = snapshotImage
            snapshotImageView.isHidden = false
            scrollView.isHidden = true
            backButton.isHidden = true
            stopDeviceMotion()
            
            self.snapshotImageView.addSubview(self.topView)
            
            snapshotImageView.scaleX = scalePercent
            snapshotImageView.scaleY = scalePercent
            topView.x = -topView.frame.size.width / scalePercent
            
            snapshotImageView.animateTo()
            topView.animateTo()
            
            bottomView.y = 0
            bottomView.animateTo()
            
            dateCheckbox.checkState = .unchecked
            descCheckbox.checkState = .unchecked
        }
        else {
            self.view.addSubview(topView)
            _ = topView.subviews.map { $0.transform = CGAffineTransform.identity }
            backButton.isHidden = false
            
            snapshotImageView.scaleX = 1
            snapshotImageView.scaleY = 1
            
            snapshotImageView.animateToNext(completion: { 
                self.snapshotImageView.isHidden = true
                self.scrollView.isHidden = false
                self.startDeviceMotion()
            })
            
            topView.x = 0
            topView.animateTo()
            
            bottomView.y = 200
            bottomView.animateTo()
        }
        
    }
    
    func onSwipChanged(sender: UISwipeGestureRecognizer) {
        
        if sender.direction == .left {
            showNext(direction: .forward)
        }
        else if sender.direction == .right {
            showNext(direction: .reverse)
        }
    }
    
    
    func startDeviceMotion() {
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
    
    func stopDeviceMotion() {
        motionManager.stopDeviceMotionUpdates()
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
        
        DispatchQueue.global().async {
            SpeechSynthesizerManager.sharedInstance.cancel()
            SpeechSynthesizerManager.sharedInstance.speak(sentence: tempWallpaperModel.desc)
        }
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
        
        snapshotImageView.isHidden = true
        
        bottomView.transform = CGAffineTransform(translationX: 0, y: 200)
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
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let homeScreenVC = segue.destination as? WallpaperHomeScreenViewController {
            homeScreenVC.snapshotImage = snapshotImage
        }
    }
    
    @IBAction func saveTapped(_ sender: UIButton) {
        if let saveImage = snapshotImageView.snapshotImage(afterScreenUpdates: false) {
            UIImageWriteToSavedPhotosAlbum(saveImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeMutableRawPointer) {
        if error == nil {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.mode = .text
            hud.label.text = "已保存至相册"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                hud.hide(animated: true)
            })
        }
    }
    
    @IBAction func previewTapped(_ sender: UIButton) {
    }
    
    @IBAction func shareToSNSTapped(_ sender: UIButton) {
        
        guard let shareImage = snapshotImageView.snapshotImage(afterScreenUpdates: false) else {
            return
        }
        
        guard let shareText = imageModelArray[currentIndex].desc else {
            return
        }
        
        let tag = sender.tag
        var platformType: SSDKPlatformType = .typeAny
        switch tag {
        case 100:
            print("微信好友")
            platformType = .subTypeWechatSession
            break
        case 101:
            print("微信朋友圈")
            platformType = .subTypeWechatTimeline
        case 102:
            print("新浪微博")
            platformType = .typeSinaWeibo
        case 103:
            print("QQ")
            platformType = .typeQQ
        case 104:
            print("QQ空间")
            platformType = .subTypeQZone
        default:
            break
        }
        
        ShareManager.shareNoUI(text: shareText, thumbImages: shareImage, images: shareImage, url: nil, title: "最美壁纸", platformType: platformType)
    }
    
    @IBAction func shareMoreTapped(_ sender: UIButton) {
        guard let shareImage = snapshotImageView.snapshotImage(afterScreenUpdates: false) else {
            return
        }
        
        guard let shareText = imageModelArray[currentIndex].desc else {
            return
        }
        
        let activityVC = UIActivityViewController(activityItems: [shareImage, shareText], applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }
    @IBAction func checkboxStateChanged(_ sender: M13Checkbox) {
        if dateCheckbox.checkState == .checked || descCheckbox.checkState == .checked {
            topView.x = 0
        }
        else {
            topView.x = -topView.frame.size.width / scalePercent
        }
        
        topView.animateTo()
        
        let dateChecked = dateCheckbox.checkState == .checked
        let dateTranslationX = dateChecked ? 0 : -topView.frame.size.width / scalePercent
        
        let descChecked = descCheckbox.checkState == .checked
        let descTranslationX = descChecked ? 0 : -topView.frame.size.width / scalePercent
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.layoutSubviews, .curveEaseOut], animations: { 
            self.dayLabel.transform = CGAffineTransform(translationX: dateTranslationX, y: 0)
            self.monthLabel.transform = CGAffineTransform(translationX: dateTranslationX, y: 0)
            self.weekLabel.transform = CGAffineTransform(translationX: dateTranslationX, y: 0)
            self.descDashLabel.transform = CGAffineTransform(translationX: descTranslationX, y: 0)
        })
    }
}
