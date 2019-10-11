//
//  BaseViewController.swift
//  WorldPicture
//
//  Created by 霹雳火 on 2019/10/11.
//  Copyright © 2019 ChaosVoid. All rights reserved.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    var disposeBag = DisposeBag()
    
    var isNavigationBarHidden: Bool { return false }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fd_prefersNavigationBarHidden = isNavigationBarHidden
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
