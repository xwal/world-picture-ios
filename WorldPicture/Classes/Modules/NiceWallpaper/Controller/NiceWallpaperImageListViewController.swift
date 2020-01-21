//
//  NiceWallpaperImageListViewController.swift
//  WorldPicture
//
//  Created by Chaosky on 2017/2/9.
//  Copyright © 2017年 ChaosVoid. All rights reserved.
//

import UIKit
import MJRefresh
import Alamofire

class NiceWallpaperImageListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var categoryId: Int!
    var categoryName: String!

    @IBOutlet weak var imageListTableView: UITableView!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    private var currentTime: Int = 0
    
    private var baseUrl: String!
    
    private var dataSourceArray = [NiceWallpaperImageModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        
        imageListTableView.mj_header?.beginRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func backButtonClicked(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    func setupView() {
        
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.image = Asset.NiceWallpaper.personalPicDefault.image
        backgroundImageView.clipsToBounds = true
        
        automaticallyAdjustsScrollViewInsets = false
        imageListTableView.separatorStyle = .none
        imageListTableView.tableFooterView = UIView()
        imageListTableView.backgroundColor = UIColor.clear
        imageListTableView.dataSource = self
        imageListTableView.delegate = self
        imageListTableView.rowHeight = UIScreen.main.bounds.size.width
        
        imageListTableView.register(UINib(nibName: "NiceWallpaperCategoryImageCell", bundle: nil), forCellReuseIdentifier: "NiceWallpaperCategoryImageCell")
        
        addHeader()
    }
    
    func addHeader() {
        let header = DropDownRefreshHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.currentTime = 0
            self.requestImageList(time: self.currentTime)
        })
        imageListTableView.mj_header = header
    }
    
    func addFooter() {
        if imageListTableView.mj_footer == nil {
            let footer = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
                guard let self = self else { return }
                if let lastPubTime = self.dataSourceArray.last?.publish_at {
                    self.currentTime = lastPubTime
                } else {
                    self.currentTime = 0
                }
                self.requestImageList(time: self.currentTime)
            })
            footer.loadingView?.style = .white
            footer.isRefreshingTitleHidden = true
            imageListTableView.mj_footer = footer
        }
    }
    
    func removeFooter() {
        imageListTableView.mj_footer = nil
    }
    
    func requestImageList(time: Int) {
        let pixelSize = UIScreen.main.nativeBounds
        let resolution = "{\(Int(pixelSize.width)), \(Int(pixelSize.height))}"
        let urlParams: [String: Any] = [
            "page_size":"20",
            "platform":"iphone",
            "resolution": resolution,
            "publish_at": time
            ]
        let url = String(format: NGPAPI_ZUIMEIA_TAG, categoryId)
        Alamofire.request(url, method: .get, parameters: urlParams).validate(statusCode: 200..<300)
        .responseJSON { [weak self] response in
            guard let self = self else { return }
            guard let JSON = response.result.value, let model = NiceWallpaperModel.yy_model(withJSON: JSON), let images = model.data?.images, let hasNext = model.data?.has_next else {
                DispatchQueue.main.async {
                    self.imageListTableView.mj_header?.endRefreshing()
                    if (self.imageListTableView.mj_footer != nil) {
                        self.imageListTableView.mj_footer?.endRefreshing()
                    }
                }
                return
            }
            
            if let base_url = model.data?.base_url {
                self.baseUrl = base_url
            }
            
            if time == 0 {
                self.dataSourceArray.removeAll()
            }
            
            self.dataSourceArray.append(contentsOf: images)
            
            DispatchQueue.main.async {
                self.imageListTableView.reloadData()
                self.imageListTableView.mj_header?.endRefreshing()
                
                if self.imageListTableView.mj_footer != nil {
                    self.imageListTableView.mj_footer?.endRefreshing()
                }
                
                self.addFooter()
        
                if hasNext {
                    self.imageListTableView.mj_footer?.endRefreshing()
                }
                else {
                    self.imageListTableView.mj_footer?.endRefreshingWithNoMoreData()
                }
            }
        }
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
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NiceWallpaperCategoryImageCell", for: indexPath) as! NiceWallpaperCategoryImageCell
        let model = dataSourceArray[indexPath.row]
        cell.model = model
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSourceArray[indexPath.row]
        backgroundImageView.kf.setImage(with: URL(string: "\(NGPAPI_ZUIMEIA_BASE_URL)\(model.image_url ?? "")"), options: [.transition(.fade(0.5))])
        
        let niceWallpaperDetailVC = StoryboardScene.NiceWallpaper.niceWallpaperDetailViewController.instantiate()
        niceWallpaperDetailVC.hidesBottomBarWhenPushed = true
        niceWallpaperDetailVC.imageModelArray = dataSourceArray
        niceWallpaperDetailVC.currentIndex = indexPath.row
        
        navigationController?.pushViewController(niceWallpaperDetailVC, animated: true)
        
    }

}
