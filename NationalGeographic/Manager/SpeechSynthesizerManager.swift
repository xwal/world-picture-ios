//
//  SpeechSynthesizerManager.swift
//  NationalGeographic
//
//  Created by Chaosky on 2016/12/16.
//  Copyright © 2016年 ChaosVoid. All rights reserved.
//

import UIKit

class SpeechSynthesizerManager: NSObject {
    private let ShakeKey = "ShakeEnabled"
    static let sharedInstance = SpeechSynthesizerManager()
    
    private override init() {
        super.init()
        UserDefaults.standard.register(defaults: [ShakeKey: true])
    }
    
    func setupBDSpeech() {
        BDSSpeechSynthesizer.sharedInstance()?
            .setApiKey("d8qGsGi7xrleOpmicY93qFoU", withSecretKey: "7468e4dc5883cc32695b8ce4e69c9067")
        // 日志级别
        BDSSpeechSynthesizer.setLogLevel(BDS_PUBLIC_LOG_ERROR)
        // 设置离线引擎
        loadOfflineTTS()
    }
    
    private func loadOfflineTTS() {
        let offlineSpeechData = Bundle.main.path(forResource: "Chinese_And_English_Speech_Female", ofType: "dat")
        let offlineTextData = Bundle.main.path(forResource: "Chinese_And_English_Text", ofType: "dat")
        
        let loadErr = BDSSpeechSynthesizer.sharedInstance()?.loadOfflineEngine(offlineTextData,
                                                                               speechDataPath: offlineSpeechData,
                                                                               licenseFilePath: nil,
                                                                               withAppCode: "9084081")
        
        if loadErr != nil {
            print(loadErr!)
        }
    }
    
    func speak(sentence: String!) {
        
        if isEnabled && sentence != nil {
            // 开始合成并播放
            for subSentence in sentence.components(separatedBy: "\n") {
                if subSentence.isEmpty {
                    continue
                }
                var error: NSError? = nil
                BDSSpeechSynthesizer.sharedInstance().speakSentence(subSentence, withError: &error)
                
                if let error = error {
                    print("错误：\(error.code) 描述：\(error.localizedDescription)")
                }
            }
        }
    }
    
    func speak(promptSentence: String!) {
        cancel()
        if promptSentence != nil {
            var error: NSError? = nil
            BDSSpeechSynthesizer.sharedInstance().speakSentence(promptSentence, withError: &error)
            
            if error != nil {
                print("error: \(error?.localizedDescription ?? "")")
            }
        }
    }
    
    func cancel() {
        BDSSpeechSynthesizer.sharedInstance().cancel()
    }
    
    var isEnabled: Bool {
        set {
            let standardUserDefault = UserDefaults.standard
            standardUserDefault.set(newValue, forKey: ShakeKey)
            standardUserDefault.synchronize()
        }
        get {
            let standardUserDefault = UserDefaults.standard
            return standardUserDefault.bool(forKey: ShakeKey)
        }
    }
    
}
