//
//  EasyView.swift
//  NationalGeographic
//
//  Created by Chaosky on 2016/11/21.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

public let DidSelectEasyCellNotification = "DidSelectEasyCellNotification"
private let reuseIdentifier = "EasyCell"
class EasyView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    var articles = [PictorialArticleModel]() {
        didSet {
            easyTableView.reloadData()
        }
    }
    
    private var easyTableView: UITableView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        easyTableView = UITableView()
        self.addSubview(easyTableView)
        easyTableView.rowHeight = 82
        self.easyTableView.backgroundColor = UIColor.clear
        self.easyTableView.showsVerticalScrollIndicator = false
        self.easyTableView.showsHorizontalScrollIndicator = false
        self.easyTableView.separatorStyle = .none
        
        easyTableView.snp.makeConstraints { (maker) in
            maker.width.equalTo(100)
            maker.height.equalTo(self.snp.width)
            maker.center.equalTo(self.snp.center)
        }
        
        easyTableView.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
        
        easyTableView.delegate = self
        easyTableView.dataSource = self
        
        easyTableView.register(UINib(nibName: "EasyCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! EasyCell
        cell.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
        let model = articles[indexPath.row]
        cell.easyImageView.kf.setImage(with: URL(string: model.image_url!), placeholder: Image(named: "ArticleCellPlaceholder"), options: [.transition(.fade(0.5))])
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: DidSelectEasyCellNotification), object: nil, userInfo: ["Models": articles, "Index": indexPath.row])
    }

}
