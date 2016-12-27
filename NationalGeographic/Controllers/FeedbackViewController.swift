//
//  FeedbackViewController.swift
//  NationalGeographic
//
//  Created by Chaosky on 2016/12/20.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit
import AVOSCloud
import MBProgressHUD

class FeedbackViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.textView.layer.cornerRadius = 5
        self.textView.layer.masksToBounds = true
        textView.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func backTapped(_ sender: UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func commitTapped(_ sender: UIBarButtonItem) {
        guard let feedbackDesc = textView.text, let contact = emailTextField.text else {
            return
        }
        
        if feedbackDesc.characters.count == 0 || contact.characters.count == 0 {
            return
        }
        
        let feedBackObj = AVObject(className: "FeedBack")
        feedBackObj.setObject(feedbackDesc, forKey: "FeedBackDesc")
        feedBackObj.setObject(contact, forKey: "Contact")
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "反馈中..."
        feedBackObj.saveInBackground { (success, error) in
            if success {
                hud.mode = .text
                hud.label.text = "反馈成功"
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: { 
                    hud.hide(animated: true)
                    _ = self.navigationController?.popViewController(animated: true)
                })
            }
            else {
                hud.mode = .text
                hud.label.text = "反馈失败"
                hud.detailsLabel.text = "请稍候再试"
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: { 
                    hud.hide(animated: true)
                })
            }
        }
        
    }
}
