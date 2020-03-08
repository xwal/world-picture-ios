//
//  HUD.swift
//  MTViewer
//
//  Created by XUXIAOTENG on 17/05/2017.
//  Copyright © 2017 GXM. All rights reserved.
//

import UIKit

public class HUD: UIView {
    
    public var containerView: UIView?
    public var offset: CGFloat = 0
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .white)
        activity.color = UIColor.gray
        return activity
    }()
    
    public convenience init(container view: UIView) {
        self.init()
        containerView = view
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        activityIndicatorView.center = CGPoint(x: self.center.x, y: self.center.y - offset)
    }
    
    public func show() {
        if let view = containerView {
            if  !view.subviews.contains(self) {
                self.alpha = 1.0
                self.frame.origin = CGPoint.zero
                self.frame.size = view.frame.size
                self.autoresizingMask = [.flexibleHeight, .flexibleWidth]
                view.addSubview(self)
                
                self.addSubview(activityIndicatorView)
                activityIndicatorView.center = CGPoint(x: self.center.x, y: self.center.y - offset)
                activityIndicatorView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            }
            activityIndicatorView.startAnimating()
        }
    }
    
    public func hide() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0.0
        }, completion: { _ in
            self.activityIndicatorView.stopAnimating()
            self.removeFromSuperview()
        })
    }
    
    public class func show(inView view: UIView? = nil, color: UIColor? = nil, offset: CGFloat? = nil) {
        let view: UIView = view ?? UIApplication.shared.keyWindow!
        let hud = HUD(container: view)
        if color != nil {
            hud.activityIndicatorView.color = color
        }
        if let offset = offset {
            hud.offset = offset
        }
        hud.show()
    }
    
    public class func show(inView view: UIView? = nil, interaction: Bool) {
        let view: UIView = view ?? UIApplication.shared.keyWindow!
        let hud = HUD(container: view)
        hud.isUserInteractionEnabled = !interaction
        hud.show()
    }
    
    public class func hide(forView view: UIView? = nil, immediate: Bool = false) {
        let view: UIView = view ?? UIApplication.shared.keyWindow!
        for subView in view.subviews where subView is HUD {
            if let hud = subView as? HUD {
                if immediate {
                    hud.removeFromSuperview()
                } else {
                    UIView.animate(withDuration: 0.3, animations: {
                        hud.alpha = 0.0
                    }, completion: { _ in
                        hud.removeFromSuperview()
                    })
                }
            }
        }
    }
    
}
