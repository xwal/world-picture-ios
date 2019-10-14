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

private let cellIdentifier = "NiceWallpaperCell"

var niceWallpaperImageBaseURL = ""

class NiceWallpaperViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    var dataSourceArray = [NiceWallpaperImageModel]()
    var currentTime: TimeInterval = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        firstLoadCache()
    }
    
    func firstLoadCache() {
        tableView.mj_header.beginRefreshing()
    }
    
    func addFooter() {
        if tableView.mj_footer == nil {
            let footer = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
                guard let self = self else { return }
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
            tableView.mj_footer = footer
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

        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.image = Asset.NiceWallpaper.personalPicDefault.image
        backgroundImageView.clipsToBounds = true
        
        let blurEffect = UIBlurEffect(style: .light)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.alpha = 0.6
        backgroundImageView.addSubview(visualEffectView)
        visualEffectView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(backgroundImageView)
        }
        
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UIScreen.main.bounds.size.width;
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        let header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.currentTime = 0
            self.requestNiceWallpaperList(time: self.currentTime)
        })
        header?.stateLabel.textColor = UIColor.white
        header?.stateLabel.isHidden = true
        header?.lastUpdatedTimeLabel.isHidden = true
        header?.activityIndicatorViewStyle = .white
        tableView.mj_header = header
        
        let leftButton = UIButton(type: .custom)
        leftButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        leftButton.tintColor = UIColor.clear
        leftButton.setImage(Asset.NiceWallpaper.iconCategory.image, for: .normal)
        leftButton.addTarget(self, action: #selector(clickCategoryButton(sender:)), for: .touchUpInside)
        
        let leftBarItem = UIBarButtonItem(customView: leftButton)
        navigationItem.leftBarButtonItem = leftBarItem
    }
    
    @objc func clickCategoryButton(sender: UIButton) {
        let categoryVC = StoryboardScene.NiceWallpaper.niceWallpaperCategoryViewController.instantiate()
        navigationController?.pushViewController(categoryVC, animated: true)
    }
    
    func requestNiceWallpaperList(time: Double) {
        
        APIProvider.request(ZuimeiaAPI.everydayWallpaper(time: time, pageSize: 20).multiTarget) { [weak self] result in
            guard let self = self else { return }
            if let response = try? result.get(),
                let model = NiceWallpaperModel.yy_model(withJSON: response.data),
                let images = model.data?.images,
                let hasNext = model.data?.has_next {
                if let base_url = model.data?.base_url {
                    niceWallpaperImageBaseURL = base_url
                }
                
                if time == 0 {
                    self.dataSourceArray.removeAll()
                }
                
                self.dataSourceArray.append(contentsOf: images)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.tableView.mj_header.endRefreshing()
                    self.addFooter()
                    if hasNext {
                        self.tableView.mj_footer.endRefreshing()
                    }
                    else {
                        self.tableView.mj_footer.endRefreshingWithNoMoreData()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.tableView.mj_header.endRefreshing()
                    
                    if (self.tableView.mj_footer != nil) {
                        self.tableView.mj_footer.endRefreshing()
                    }
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
        navigationController?.setNavigationBarHidden(false, animated: true)
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
        backgroundImageView.kf.setImage(with: URL(string: "\(niceWallpaperImageBaseURL)\(model.image_url ?? "")"), options: [.transition(.fade(0.5))])

        let niceWallpaperDetailVC = StoryboardScene.NiceWallpaper.niceWallpaperDetailViewController.instantiate()
        niceWallpaperDetailVC.hidesBottomBarWhenPushed = true
        niceWallpaperDetailVC.imageModelArray = dataSourceArray
        niceWallpaperDetailVC.currentIndex = indexPath.row
        
        navigationController?.pushViewController(niceWallpaperDetailVC, animated: true)
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
