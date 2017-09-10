//
//  NiceWallpaperImageListViewController.swift
//  NationalGeographic
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
        
        self.imageListTableView.mj_header.beginRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func backButtonClicked(_ sender: UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func setupView() {
        
        self.backgroundImageView.contentMode = .scaleAspectFill
        self.backgroundImageView.image = UIImage(named: "personal_pic_default")
        self.backgroundImageView.clipsToBounds = true
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.imageListTableView.separatorStyle = .none
        self.imageListTableView.tableFooterView = UIView()
        self.imageListTableView.backgroundColor = UIColor.clear
        self.imageListTableView.dataSource = self
        self.imageListTableView.delegate = self
        self.imageListTableView.rowHeight = UIScreen.main.bounds.size.width
        
        self.imageListTableView.register(UINib(nibName: "NiceWallpaperCategoryImageCell", bundle: nil), forCellReuseIdentifier: "NiceWallpaperCategoryImageCell")
        
        addHeader()
    }
    
    func addHeader() {
        let header = MJRefreshNormalHeader(refreshingBlock: {
            self.currentTime = 0
            self.requestImageList(time: self.currentTime)
        })
        header?.arrowView.image = UIImage(named: "whiteArrow")
        header?.stateLabel.isHidden = true
        header?.lastUpdatedTimeLabel.isHidden = true
        header?.activityIndicatorViewStyle = .white
        self.imageListTableView.mj_header = header
    }
    
    func addFooter() {
        if self.imageListTableView.mj_footer == nil {
            let footer = MJRefreshAutoNormalFooter(refreshingBlock: {
                if let lastPubTime = self.dataSourceArray.last?.publish_at {
                    self.currentTime = lastPubTime
                } else {
                    self.currentTime = 0
                }
                self.requestImageList(time: self.currentTime)
            })
            footer?.activityIndicatorViewStyle = .white
            footer?.isRefreshingTitleHidden = true
            self.imageListTableView.mj_footer = footer
        }
    }
    
    func removeFooter() {
        self.imageListTableView.mj_footer = nil
    }
    
    func requestImageList(time: Int) {
        let pixelSize = UIScreen.main.sizeInPixel
        let resolution = "{\(Int(pixelSize.width)), \(Int(pixelSize.height))}"
        let urlParams: [String: Any] = [
            "page_size":"20",
            "platform":"iphone",
            "resolution": resolution,
            "publish_at": time
            ]
        let url = String(format: NGPAPI_ZUIMEIA_TAG, self.categoryId)
        Alamofire.request(url, method: .get, parameters: urlParams).validate(statusCode: 200..<300)
        .responseJSON { response in
            guard let JSON = response.result.value, let model = NiceWallpaperModel.yy_model(withJSON: JSON), let images = model.data?.images, let hasNext = model.data?.has_next else {
                DispatchQueue.main.async {
                    self.imageListTableView.mj_header.endRefreshing()
                    if (self.imageListTableView.mj_footer != nil) {
                        self.imageListTableView.mj_footer.endRefreshing()
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
                self.imageListTableView.mj_header.endRefreshing()
                
                if self.imageListTableView.mj_footer != nil {
                    self.imageListTableView.mj_footer.endRefreshing()
                }
                
                self.addFooter()
        
                if hasNext {
                    self.imageListTableView.mj_footer.endRefreshing()
                }
                else {
                    self.imageListTableView.mj_footer.endRefreshingWithNoMoreData()
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
        self.backgroundImageView.kf.setImage(with: URL(string: "\(NGPAPI_ZUIMEIA_BASE_URL)\(model.image_url ?? "")"), options: [.transition(.fade(0.5))])
        
        guard let niceWallpaperDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "NiceWallpaperDetailViewController") as? NiceWallpaperDetailViewController else {
            return
        }
        niceWallpaperDetailVC.hidesBottomBarWhenPushed = true
        niceWallpaperDetailVC.imageModelArray = self.dataSourceArray
        niceWallpaperDetailVC.currentIndex = indexPath.row
        
        self.navigationController?.pushViewController(niceWallpaperDetailVC, animated: true)
        
    }

}
