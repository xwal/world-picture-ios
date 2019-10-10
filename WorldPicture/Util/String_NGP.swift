//
//  String+NGP.swift
//  WorldPicture
//
//  Created by Chaosky on 2016/11/24.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import Foundation

extension String {
    
    func replaceControlCharacters() -> String {
        
        var str  = self
        str = str.replacingOccurrences(of: "\t", with: "\\t")
        str = str.replacingOccurrences(of: "\r", with: "\\r")
        str = str.replacingOccurrences(of: "\n", with: "\\n")
        
        return str
    }
    
    func removeControlCharacters() -> String {
        
        let controlChars = CharacterSet.controlCharacters
        
        var str  = self
        
        while let range = str.rangeOfCharacter(from: controlChars) {
            str.removeSubrange(range)
        }
        
        return str
    }
}
