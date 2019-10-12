//
//  NiceWallpaperDetailViewController.swift
//  WorldPicture
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
import FDFullscreenPopGesture

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
    @IBOutlet weak var dateDescLabel: UILabel!
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
        view.addGestureRecognizer(leftSwipGesture)
        
        let rightSwipGesture = UISwipeGestureRecognizer(target: self, action: #selector(onSwipChanged(sender:)))
        rightSwipGesture.direction = [.right]
        view.addGestureRecognizer(rightSwipGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onSnapshotTapped(sender:)))
        view.addGestureRecognizer(tapGesture)
        
        let bottomTapGesture = UITapGestureRecognizer(target: nil, action: nil)
        bottomView.addGestureRecognizer(bottomTapGesture)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SpeechSynthesizerManager.sharedInstance.cancel()
    }
    
    @objc func onSnapshotTapped(sender: UITapGestureRecognizer) {
        if snapshotImageView.layer.animationKeys() != nil {
            return
        }
        if snapshotImageView.isHidden {
            snapshotImage = scrollView.createSnapshotImage()
            snapshotImageView.image = snapshotImage
            snapshotImageView.isHidden = false
            scrollView.isHidden = true
            backButton.isHidden = true
            stopDeviceMotion()
            
            snapshotImageView.addSubview(topView)
            
            snapshotImageView.scaleX = scalePercent
            snapshotImageView.scaleY = scalePercent
            (topView as Springable).x = -topView.frame.size.width / scalePercent
            
            snapshotImageView.animateTo()
            topView.animateTo()
            
            (bottomView as Springable).y = 0
            bottomView.animateTo()
            
            dateCheckbox.checkState = .unchecked
            descCheckbox.checkState = .unchecked
        }
        else {
            view.addSubview(topView)
            _ = topView.subviews.map { $0.transform = CGAffineTransform.identity }
            backButton.isHidden = false
            
            snapshotImageView.scaleX = 1
            snapshotImageView.scaleY = 1
            
            snapshotImageView.animateToNext(completion: { [weak self] in
                guard let self = self else { return }
                self.snapshotImageView.isHidden = true
                self.scrollView.isHidden = false
                self.startDeviceMotion()
            })
            
            (topView as Springable).x = 0
            topView.animateTo()
            
            (bottomView as Springable).y = 400
            bottomView.animateTo()
        }
        
    }
    
    @objc func onSwipChanged(sender: UISwipeGestureRecognizer) {
        
        if snapshotImageView.isHidden == false {
            return
        }
        
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
            motionManager.deviceMotionUpdateInterval = 1 / 100.0
            // 采样
            motionManager.startDeviceMotionUpdates(to: OperationQueue(), withHandler: { [weak self] (deviceMotion, error) in
                guard let self = self else { return }
                if error != nil {
                    return
                }
                guard let attitude = deviceMotion?.attitude else {
                    return
                }
                DispatchQueue.main.async {
                    self.scrollRoll(rate: attitude.roll)
                }
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
        
        wallpaperImageView.kf.setImage(with: URL(string: "\(niceWallpaperImageBaseURL)\(tempWallpaperModel.image_url ?? "")"), options: [.transition(.fade(0.5))], completionHandler: { [weak self] handler in
            guard let self = self else { return }
            self.view.setNeedsLayout()
        })
        
        descDashLabel.stopAnimation()
        
        descDashLabel.text = tempWallpaperModel.desc?.length != 0 ? tempWallpaperModel.desc : "喜欢这张图就帮它配词吧~"
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        style.alignment = .left
        style.minimumLineHeight = 18
        let attrString = NSAttributedString(string: descDashLabel.text, attributes: [.paragraphStyle: style,  .font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.white])
        
        descDashLabel.attributedString = attrString
        
        view.layoutIfNeeded()
        descDashLabel.sizeToFit()
        descDashLabel.startAppearAnimation()
        
        if let pubTime = tempWallpaperModel.pub_time {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en")
            formatter.dateFormat = "dd,MMM,EEEE"
            
            let formatDateStr = formatter.string(from: pubTime)
            let dateArray = formatDateStr.components(separatedBy: ",")
            dayLabel.isHidden = false
            monthLabel.isHidden = false
            weekLabel.isHidden = false
            dateCheckbox.isHidden = false
            dateDescLabel.text = "显示日期"
            dayLabel.text = dateArray[0]
            monthLabel.text = dateArray[1]
            weekLabel.text = dateArray[2]
        }
        else {
            dayLabel.isHidden = true
            monthLabel.isHidden = true
            weekLabel.isHidden = true
            dateCheckbox.isHidden = true
            dateDescLabel.text = nil
        }
        
        if view.layer.animation(forKey: "aniKey") == nil {
            let transition = CATransition()
            transition.type = CATransitionType.fade
            transition.duration = 1
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            
            // This makes the animation go.
            view.layer.add(transition, forKey: "aniKey")
        }
        
        DispatchQueue.global().async {
            SpeechSynthesizerManager.sharedInstance.cancel()
            SpeechSynthesizerManager.sharedInstance.speak(sentence: tempWallpaperModel.desc)
        }
    }
    
    func setupViews() {
        fd_prefersNavigationBarHidden = true
        fd_interactivePopDisabled = true
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = false
        
        scrollView.addSubview(wallpaperImageView)
        wallpaperImageView.contentMode = .scaleAspectFill
        
        snapshotImageView.isHidden = true
        
        bottomView.transform = CGAffineTransform(translationX: 0, y: 400)
    }
    
    func scrollRoll(rate: Double) {
        if rate > -0.1 && rate < 0.1 {
            return
        }
        var contentOffset = scrollView.contentOffset
        
        let rightX = scrollView.contentSize.width - UIScreen.main.bounds.width
        
        contentOffset.x -= CGFloat(rate * 3)
        
        if contentOffset.x <= 0 {
            contentOffset.x = 0
        }
        
        if contentOffset.x >= rightX  {
            contentOffset.x = rightX
        }
        
        scrollView.contentOffset = contentOffset
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let image = wallpaperImageView.image else { return }
        let containerSize = scrollView.size
        let imageHeight = containerSize.height
        var imageWidth = (image.size.width / image.size.height) * imageHeight
        imageWidth = fmax(imageWidth, containerSize.width)
        wallpaperImageView.frame = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
        
        scrollView.contentSize = CGSize(width: imageWidth, height: imageHeight)
        
        let offsetX = (imageWidth - containerSize.width) / 2
        scrollView.contentOffset = CGPoint(x: offsetX, y: 0)
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
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
        if let saveImage = snapshotImageView.screenshot {
            Utils.writeImageToPhotosAlbum(saveImage)
        }
    }
    
    @IBAction func previewTapped(_ sender: UIButton) {
    }
    
    @IBAction func shareMoreTapped(_ sender: UIButton) {
        guard let shareImage = snapshotImageView.screenshot else {
            return
        }
        
        guard let shareText = imageModelArray[currentIndex].desc else {
            return
        }
        
        let activityVC = UIActivityViewController(activityItems: [shareImage, shareText], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }
    @IBAction func checkboxStateChanged(_ sender: M13Checkbox) {
        topView.layer.removeAllAnimations()
        if dateCheckbox.checkState == .checked || descCheckbox.checkState == .checked {
            (topView as Springable).x = 0
        }
        else {
            (topView as Springable).x = -topView.frame.size.width / scalePercent
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
