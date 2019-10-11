//
//  HistoryRecordManager.swift
//  WorldPicture
//
//  Created by Chaosky on 2016/11/16.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit

class HistoryRecordManager: NSObject {
    static let shared = HistoryRecordManager()
    
    private var historyRecord = [String]()
    
    private lazy var saveURL: URL = {
        let saveFilePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0].appendingPathComponent("HistoryRecord.data")
        return URL(fileURLWithPath: saveFilePath)
    }()
    
    private override init() {
        super.init()
        read()
    }
    
    func add(_ albumId: String) {
        historyRecord.append(albumId)
        save()
    }
    
    func check(_ albumId: String) -> Bool {
        return historyRecord.contains(albumId)
    }
    
    private func save() {
        (historyRecord as NSArray).write(to: saveURL, atomically: true)
    }
    
    private func read() {
        if let recordArray = NSArray(contentsOf: saveURL) {
            historyRecord = recordArray as! Array<String>
        }
    }
}
