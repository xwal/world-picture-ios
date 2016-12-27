//
//  UIApplication_NGP.swift
//  NationalGeographic
//
//  Created by Chaosky on 2016/12/27.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit

extension UIApplication {
    
    static func findBest(_ vc: UIViewController) -> UIViewController {
        
        if let presentVC = vc.presentedViewController {
            return findBest(presentVC)
        }
        else if let svc = vc as? UISplitViewController {
            if let last = svc.viewControllers.last {
                return findBest(last)
            }
            else {
                return vc
            }
        }
        else if let nvc = vc as? UINavigationController {
            
            if let topVC = nvc.topViewController {
                return findBest(topVC)
            }
            else {
                return vc
            }
        }
        else if let tabbarVC = vc as? UITabBarController {
            
            if let selectedVC = tabbarVC.selectedViewController {
                return findBest(selectedVC)
            }
            else {
                return vc
            }
        }
        else {
            return vc
        }
    }
    
    static var currentViewController: UIViewController? {
        if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
            return findBest(rootVC)
        }
        else {
            return nil
        }
    }
}
