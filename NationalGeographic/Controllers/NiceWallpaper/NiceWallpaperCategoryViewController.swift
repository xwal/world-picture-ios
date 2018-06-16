//
//  NiceWallpaperCategoryViewController.swift
//  NationalGeographic
//
//  Created by Chaosky on 2017/2/9.
//  Copyright © 2017年 ChaosVoid. All rights reserved.
//

import UIKit
import YYCategories
import CHTCollectionViewWaterfallLayout
import Alamofire

class NiceWallpaperCategoryViewController: UIViewController, CHTCollectionViewDelegateWaterfallLayout, UICollectionViewDataSource {

    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    @IBOutlet weak var cvLayout: CHTCollectionViewWaterfallLayout!
    
    private var categoryModel: NiceWallpaperCategoryModel?
    
    private var baseURL: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        requestWallpaperCategoryList()
    }
    
    func setupView() {
        cvLayout.columnCount = 2
        cvLayout.minimumColumnSpacing = 0
        cvLayout.minimumInteritemSpacing = 0
        
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        
        categoryCollectionView.register(UINib(nibName: "NiceWallpaperCategoryCell", bundle: nil), forCellWithReuseIdentifier: "NiceWallpaperCategoryCell")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func requestWallpaperCategoryList() {
        let pixelSize = UIScreen.main.sizeInPixel
        let resolution = "{\(Int(pixelSize.width)), \(Int(pixelSize.height))}"
        let urlParams = [
            "platform":"iphone",
            "resolution": resolution
            ]
        let url = URL(string: NGPAPI_ZUIMEIA_CATEGORY_LIST)!
        let originalRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        let encodedRequest = try! URLEncoding.default.encode(originalRequest, with: urlParams)
        Alamofire.request(encodedRequest).validate(statusCode: 200..<300).responseJSON { (response) in
            
            if let JSON = response.result.value, let model = NiceWallpaperCategoryModel.yy_model(withJSON: JSON) {
                self.categoryModel = model
                self.baseURL = model.data?.base_url
                
                DispatchQueue.main.async {
                    self.categoryCollectionView.reloadData()
                }
            }
        }
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowWallpaperCategory" {
            if let wpCategoryVC = segue.destination as? NiceWallpaperImageListViewController {
                
                let indexPath = sender as! IndexPath
                let tagModel = self.categoryModel?.data?.tags?[indexPath.row]
                wpCategoryVC.categoryId = tagModel?.id
                wpCategoryVC.title = tagModel?.name
            }
        }
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryModel?.data?.tags?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NiceWallpaperCategoryCell", for: indexPath) as! NiceWallpaperCategoryCell
        
        if let tagModel = self.categoryModel?.data?.tags?[indexPath.row], let baseURL = self.baseURL, let cover = tagModel.cover {
            cell.parallaxImage.kf.setImage(with: URL(string: "\(baseURL)/\(cover)"))
            cell.titleLabel.text = tagModel.name
        }
        
        return cell
    }
    
    // MARK: - CHTCollectionViewDelegateWaterfallLayout
    func collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAt indexPath: IndexPath!) -> CGSize {
        let width = UIScreen.main.currentBounds().width / 2
        let Height = width / 187.0 * 210.0
        return CGSize(width: width, height: Height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowWallpaperCategory", sender: indexPath)
    }
    
    

}
