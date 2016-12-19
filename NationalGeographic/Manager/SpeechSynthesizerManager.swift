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
        let bdsSpeech = BDSSpeechSynthesizer.sharedInstance()
        bdsSpeech?.setApiKey("d8qGsGi7xrleOpmicY93qFoU", withSecretKey: "7468e4dc5883cc32695b8ce4e69c9067")
        // 设置离线引擎
        
        let ChineseSpeechData = Bundle.main.path(forResource: "Chinese_Speech_Female", ofType: "dat")
        let ChineseTextData = Bundle.main.path(forResource: "Chinese_Text", ofType: "dat")
        let EnglishSpeechData = Bundle.main.path(forResource: "English_Speech_Female", ofType: "dat")
        let EnglishTextData = Bundle.main.path(forResource: "English_Text", ofType: "dat")
        
        var loadErr = bdsSpeech?.loadOfflineEngine(ChineseTextData, speechDataPath: ChineseSpeechData, licenseFilePath: nil, withAppCode: "9084081")
        
        if loadErr != nil {
            print(loadErr!)
        }
        
        // 加载英文资源
        loadErr = bdsSpeech?.loadEnglishData(forOfflineEngine: EnglishTextData, speechData: EnglishSpeechData)
        if loadErr != nil {
            print(loadErr!)
        }
    }
    
    func speak(sentence: String!) {
        
        if isEnabled && sentence != nil {
            // 开始合成并播放
            var error: NSError? = nil
            BDSSpeechSynthesizer.sharedInstance().speakSentence(sentence, withError: &error)
            
            if error != nil {
                print("错误：\(error?.code) 描述：\(error?.localizedDescription)")
            }
        }
    }
    
    func speak(promptSentence: String!) {
        cancel()
        if promptSentence != nil {
            var error: NSError? = nil
            BDSSpeechSynthesizer.sharedInstance().speakSentence(promptSentence, withError: &error)
            
            if error != nil {
                print("错误：\(error?.code) 描述：\(error?.localizedDescription)")
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
