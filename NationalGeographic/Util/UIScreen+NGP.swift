//
//  UIScreen+NGP.swift
//  NationalGeographic
//
//  Created by Chaosky on 2016/12/13.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import Foundation
import UIKit

extension UIScreen {
    static func screenPixelSize() -> CGSize {
        let screenSize = UIScreen.main.bounds.size
        let scale = UIScreen.main.scale
        return CGSize(width: screenSize.width * scale, height: screenSize.height * scale)
    }
    
    static var screenSize: CGSize {
        return UIScreen.main.bounds.size
    }
}
