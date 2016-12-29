//
//  ArticleDetailViewController.swift
//  NationalGeographic
//
//  Created by Chaosky on 2016/11/21.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire

class ArticleDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var articleModel: PictorialArticleModel!
    
    @IBOutlet weak var headerImageView: UIImageView!
    
    @IBOutlet weak var navbarImageView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var favariteCountLabel: UILabel!
    private var totalCount = 0
    
    private var hasDescNotes = false
    private var hasPhotos = false
    private var hasDestIntro = false
    private var descNotesCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        requestArticleFavorite()
        loadArticleModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        SpeechSynthesizerManager.sharedInstance.cancel()
        SpeechSynthesizerManager.sharedInstance.speak(sentence: self.articleModel.title)
        SpeechSynthesizerManager.sharedInstance.speak(sentence: self.articleModel.desc)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SpeechSynthesizerManager.sharedInstance.cancel()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    func setupView() {
        self.tableView.register(UINib(nibName: "ArticleSummaryCell", bundle: nil), forCellReuseIdentifier: "ArticleSummaryCell")
        self.tableView.register(UINib(nibName: "ArticleImageCell", bundle: nil), forCellReuseIdentifier: "ArticleImageCell")
        self.tableView.register(UINib(nibName: "ArticlePhotosCell", bundle: nil), forCellReuseIdentifier: "ArticlePhotosCell")
        self.tableView.register(UINib(nibName: "ArticleFooterCell", bundle: nil), forCellReuseIdentifier: "ArticleFooterCell")
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func loadArticleModel() {
        headerImageView.kf.setImage(with: URL(string: articleModel.image_url!), placeholder: Image(named: "Placeholder"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: nil)

        descNotesCount = articleModel.description_notes?.count ?? 0
        hasDescNotes = descNotesCount > 0 ? true : false
        
        hasPhotos = (articleModel.photos?.count ?? 0) > 0 ? true : false
        
        if let title = articleModel.destination_intro_title {
            if title.characters.count > 0 {
                hasDestIntro = true
            }
        }
        
        hasDestIntro = articleModel.destination_intro_title != ""
        
        totalCount = 2
        
        if hasDescNotes {
            totalCount += descNotesCount
        }
        
        if hasPhotos {
            totalCount += 1
        }
        
        if hasDestIntro {
            totalCount += 1
        }
        
        self.tableView.reloadData()
    }
    
    func requestArticleFavorite() {
        Alamofire.request("http://chanyouji.com/api/pictorials/favorites/\(articleModel.id).json").responseJSON { (response) in
            if let JSON = response.result.value {
                if let model = ArticlefavoritesModel.yy_model(withJSON: JSON) {
                    DispatchQueue.main.async {
                        self.favariteCountLabel.text = String(model.favorites_count)
                    }
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
    @IBAction func backTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func shareTapped(_ sender: UIButton) {
        ShareManager.shareActionSheet(text: articleModel.desc, thumbImages: articleModel.image_url, images: articleModel.image_url, url: URL(string: "http://chanyouji.com/pictorial_articles/\(articleModel.id)"), title: articleModel.title, type: .auto)
    }
    
    
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleSummaryCell", for: indexPath) as! ArticleSummaryCell
            cell.articleTitleLabel.text = articleModel.title
            cell.descTextView.text = articleModel.desc
            return cell
        }
        else if indexPath.row >= 1 && indexPath.row <= descNotesCount {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleImageCell", for: indexPath) as! ArticleImageCell
            cell.model = articleModel.description_notes?[indexPath.row - 1]
            return cell
        }
        else if hasPhotos && indexPath.row == descNotesCount + 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArticlePhotosCell", for: indexPath) as! ArticlePhotosCell
            cell.photos = articleModel.photos
            return cell
        }
        else if hasDestIntro && indexPath.row == totalCount - 1  {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleSummaryCell", for: indexPath) as! ArticleSummaryCell
            cell.articleTitleLabel.text = articleModel.destination_intro_title
            cell.descTextView.text = articleModel.destination_intro
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleFooterCell", for: indexPath) as! ArticleFooterCell
            cell.footerLabel.text = "图：\(articleModel.photo_author ?? "") \n文：\(articleModel.text_author ?? "")"
            return cell
        }
        
    }
}
