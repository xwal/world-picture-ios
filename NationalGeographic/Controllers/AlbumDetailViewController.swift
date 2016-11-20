//
//  DetailViewController.swift
//  NationalGeographic
//
//  Created by Chaosky on 2016/11/15.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class AlbumDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var albumID: String? = nil
    
    var pictureListModel: PictureListModel!
    
    var currentIndex = 0
    
    @IBOutlet weak var picNameLabel: UILabel!
    
    @IBOutlet weak var picIndexLabel: UILabel!
    
    @IBOutlet weak var contentWebView: UIWebView!
    
    
    
    @IBOutlet weak var pictureCollectionView: UICollectionView!
    
    @IBOutlet var showOrHideViews: [UIView]!
    
    var pageViewController: UIPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        requestAlbumDetail()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func setupView() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
//        pageViewController.delegate = self
//        pageViewController.setViewControllers(<#T##viewControllers: [UIViewController]?##[UIViewController]?#>, direction: <#T##UIPageViewControllerNavigationDirection#>, animated: <#T##Bool#>, completion: <#T##((Bool) -> Void)?##((Bool) -> Void)?##(Bool) -> Void#>)
    }
    
    func showOrHideViewsTapped() {
        UIView.animate(withDuration: 0.5, animations: {
            for view in self.showOrHideViews {
                view.alpha = view.alpha == 0 ? 1 : 0;
            }
        })
    }
    
    func requestAlbumDetail() {
        pictureCollectionView.isHidden = true
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = .indeterminate
        if albumID != nil {
            Alamofire.request("http://dili.bdatu.com/jiekou/albums/a\(albumID!).html").responseJSON(completionHandler: { (response) in
                if let JSON = response.result.value {
                    self.pictureListModel = PictureListModel.yy_model(withJSON: JSON)
                }
                DispatchQueue.main.async {
                    hud.hide(animated: true)
                    self.pictureCollectionView.isHidden = false
                    self.updateViews()
                }
            })
        }
        
    }
    
    func updateViews() {
        
        if let count = pictureListModel?.counttotal {
            picIndexLabel.text = "\(currentIndex+1)/\(count)"
        }
        
        if let currentPic = pictureListModel?.picture?[currentIndex] {
            picNameLabel.text = currentPic.title
            let html = "<html><head><meta http-equiv=\"Content-Type\" content=\"text/html;charset=utf-8\"><link href=\"jianjie.css\" type=\"text/css\" rel=\"stylesheet\"  /></head><body><p>\(currentPic.content!)（摄像：\(currentPic.author!)）</p></body></html>"
            contentWebView.loadHTMLString(html, baseURL: Bundle.main.bundleURL)
        }
        pictureCollectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func shareTapped(_ sender: UIButton) {
        guard let pictureModel = pictureListModel?.picture?[currentIndex] else {
            return
        }
        
        ShareManager.share(text: pictureModel.content, thumbImages: pictureModel.url, images: pictureModel.url, url: URL(string: pictureModel.yourshotlink!), title: pictureModel.title, type: .auto)
    }
    
    @IBAction func saveTapped(_ sender: UIButton) {
        
        let currentCell = pictureCollectionView.cellForItem(at: IndexPath(row: currentIndex, section: 0)) as! PictureCell
        
        if let image = currentCell.pictureImageView.image {
            
            if !image.isEqual(UIImage(named: "nopic")) {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            }
            
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
    
    @IBAction func backTapped(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = pictureListModel?.counttotal else {
            return 0
        }
        return Int(count) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PictureCell", for: indexPath) as! PictureCell
        cell.model = pictureListModel?.picture?[indexPath.row]
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showOrHideViewsTapped()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? PictureCell)?.pictureImageView.transform = CGAffineTransform.identity
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentIndex = pictureCollectionView.indexPathForItem(at: scrollView.contentOffset)?.row ?? 0
        updateViews()
    }

}
