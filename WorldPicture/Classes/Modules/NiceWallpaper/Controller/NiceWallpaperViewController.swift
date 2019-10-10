//
//  NiceWallpaperViewController.swift
//  WorldPicture
//
//  Created by Chaosky on 2016/12/13.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit
import MJRefresh
import Alamofire
import SnapKit
import Kingfisher
import YYCategories

private let cellIdentifier = "NiceWallpaperCell"

var niceWallpaperImageBaseURL = ""

class NiceWallpaperViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    var dataSourceArray = [NiceWallpaperImageModel]()
    var currentTime: TimeInterval = 0
    
    var isLoadCacheFinished = false {
        didSet {
            if isLoadCacheFinished == true {
                currentTime = 0
                requestNiceWallpaperList(time: 0)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        firstLoadCache()
    }
    
    func firstLoadCache() {
        isLoadCacheFinished = false
        currentTime = 0
        self.tableView.mj_header.beginRefreshing()
    }
    
    func addFooter() {
        if self.tableView.mj_footer == nil {
            let footer = MJRefreshAutoNormalFooter(refreshingBlock: {
                if let lastPubTime = self.dataSourceArray.last?.pub_time {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    self.currentTime = lastPubTime.timeIntervalSince1970
                } else {
                    self.currentTime = 0
                }
                self.requestNiceWallpaperList(time: self.currentTime)
            })
            footer?.activityIndicatorViewStyle = .white
            footer?.isRefreshingTitleHidden = true
            self.tableView.mj_footer = footer
        }
    }
    
    func createBlurImage(_ originImage: UIImage) -> UIImage? {
        
        guard let gaussianBlurFilter = CIFilter(name: "CIGaussianBlur") else {
            return nil
        }
        
        guard let originCGImage = originImage.cgImage else {
            return nil
        }
        
        let inputImage = CIImage(cgImage: originCGImage)
        
        gaussianBlurFilter.setDefaults()
        gaussianBlurFilter.setValue(inputImage, forKey: kCIInputImageKey)
        gaussianBlurFilter.setValue(5, forKey: kCIInputRadiusKey)
        
        guard let outputImage = gaussianBlurFilter.outputImage else {
            return nil
        }
        
        let context = CIContext(options: nil)
        guard let blurCGImage = context.createCGImage(outputImage, from: inputImage.extent) else {
            return nil
        }
        let blurImage = UIImage(cgImage: blurCGImage)
        return blurImage
    }
    
    func setupViews() {

        self.backgroundImageView.contentMode = .scaleAspectFill
        self.backgroundImageView.image = UIImage(named: "personal_pic_default")
        self.backgroundImageView.clipsToBounds = true
        
        let blurEffect = UIBlurEffect(style: .light)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.alpha = 0.6
        self.backgroundImageView.addSubview(visualEffectView)
        visualEffectView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(self.backgroundImageView)
        }
        
        self.tableView.separatorStyle = .none
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = UIScreen.main.bounds.size.width;
        self.tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        let header = MJRefreshNormalHeader(refreshingBlock: {
            self.currentTime = 0
            self.requestNiceWallpaperList(time: self.currentTime)
        })
        header?.stateLabel.textColor = UIColor.white
        header?.stateLabel.isHidden = true
        header?.lastUpdatedTimeLabel.isHidden = true
        header?.activityIndicatorViewStyle = .white
        self.tableView.mj_header = header
        
        let leftButton = UIButton(type: .custom)
        leftButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        leftButton.tintColor = UIColor.clear
        leftButton.setImage(Asset.NiceWallpaper.iconCategory.image, for: .normal)
        leftButton.addTarget(self, action: #selector(clickCategoryButton(sender:)), for: .touchUpInside)
        
        let leftBarItem = UIBarButtonItem(customView: leftButton)
        self.navigationItem.leftBarButtonItem = leftBarItem
    }
    
    @objc func clickCategoryButton(sender: UIButton) {
        
        if let categoryVC = self.storyboard?.instantiateViewController(withIdentifier: "NiceWallpaperCategoryViewController") {
            self.navigationController?.pushViewController(categoryVC, animated: true)
        }
    }
    
    func requestNiceWallpaperList(time: Double) {
        let pixelSize = UIScreen.main.sizeInPixel
        let resolution = "{\(Int(pixelSize.width)), \(Int(pixelSize.height))}"
        let urlParams = [
            "time": "\(Int(time))",
            "platform":"iphone",
            "resolution": resolution,
            "page_size":"20",
            ]
        
        let url = URL(string: NGPAPI_ZUIMEIA_EVERYDAY_WALLPAPER)!
        let originalRequest = URLRequest(url: url, cachePolicy: (isLoadCacheFinished ? .useProtocolCachePolicy : .returnCacheDataElseLoad))
        let encodedRequest = try! URLEncoding.default.encode(originalRequest, with: urlParams)
        Alamofire.request(encodedRequest).validate(statusCode: 200..<300).responseJSON { (response) in
            
            guard let JSON = response.result.value, let model = NiceWallpaperModel.yy_model(withJSON: JSON), let images = model.data?.images, let hasNext = model.data?.has_next else {
                
                DispatchQueue.main.async {
                    self.tableView.mj_header.endRefreshing()
                    
                    if (self.tableView.mj_footer != nil) {
                        self.tableView.mj_footer.endRefreshing()
                    }
                }
                
                return
            }
                
            if let base_url = model.data?.base_url {
                niceWallpaperImageBaseURL = base_url
            }
            
            if time == 0 {
                self.dataSourceArray.removeAll()
            }
            
            self.dataSourceArray.append(contentsOf: images)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
                if self.isLoadCacheFinished == false {
                    self.isLoadCacheFinished = true
                }
                else {
                    self.tableView.mj_header.endRefreshing()
                }
                
                self.addFooter()
                if hasNext {
                    self.tableView.mj_footer.endRefreshing()
                }
                else {
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                }
            }
        }
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return dataSourceArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! NiceWallpaperCell

        cell.imageBaseUrl = niceWallpaperImageBaseURL
        cell.model = dataSourceArray[indexPath.row]
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSourceArray[indexPath.row]
        self.backgroundImageView.kf.setImage(with: URL(string: "\(niceWallpaperImageBaseURL)\(model.image_url ?? "")"), options: [.transition(.fade(0.5))])

        guard let niceWallpaperDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "NiceWallpaperDetailViewController") as? NiceWallpaperDetailViewController else {
            return
        }
        niceWallpaperDetailVC.hidesBottomBarWhenPushed = true
        niceWallpaperDetailVC.imageModelArray = self.dataSourceArray
        niceWallpaperDetailVC.currentIndex = indexPath.row
        
        self.navigationController?.pushViewController(niceWallpaperDetailVC, animated: true)
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
