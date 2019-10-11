//
//  UIScrollView_NGP.swift
//  WorldPicture
//
//  Created by Chaosky on 2016/12/28.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit

extension UIScrollView {
    func createSnapshotImage() -> UIImage? {
        assert(Thread.isMainThread)
        
        let visiableSize = bounds.size
        UIGraphicsBeginImageContextWithOptions(visiableSize, true, UIScreen.main.scale)
        let drawRect = CGRect(origin: CGPoint(), size: visiableSize)
        drawHierarchy(in: drawRect, afterScreenUpdates: false)
        let visibleScrollViewImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return visibleScrollViewImage
    }
}
