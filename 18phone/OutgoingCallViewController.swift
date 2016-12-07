//
//  OutgoingCallViewController.swift
//  18phone
//
//  Created by 戴全艺 on 16/8/16.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit
import SwiftEventBus
import AVFoundation
import Async

class OutgoingCallViewController: UIViewController {
    
    var callLog: CallLog?
    
    var outCall: GSCall?
    
    var isHangup = false
    
    var isConnected = false
    
    let newCallLog = CallLog()
    
    /// 显示姓名或号码
    @IBOutlet weak var nameLabel: UILabel!
    
    /// 显示号码归属地
    @IBOutlet weak var areaLabel: MZTimerLabel!
    
    /// 拨号盘按钮容器
    @IBOutlet weak var dialPlateCon: UIView!
    
    /// 扬声器按钮容器
    @IBOutlet weak var speakerCon: UIView!
    
    /// 拨号盘按钮
    @IBOutlet weak var dialPlateBtn: UIButton!
    
    /// 扬声器按钮
    @IBOutlet weak var speakerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /**
         storyboard目前不支持设置CGColor
         */
        dialPlateBtn.layer.borderColor = UIColor.white.cgColor
        speakerBtn.layer.borderColor = UIColor.white.cgColor
        if !callLog!.name.isEmpty {
            nameLabel.text = callLog!.name
            areaLabel.text = "正在拨号"
        } else {
            nameLabel.text = callLog!.phone
            areaLabel.text = callLog!.area
        }
        let account = GSUserAgent.shared().account
        outCall = GSCall.outgoingCall(toUri: callLog!.accountId + "@" + AppURL.BEYEBE_SIP_DOMAIN, from: account)
        //        outCall?.checkBuddy()
        outCall?.addObserver(self, forKeyPath: "status", options: .initial, context: nil)
        App.changeSpeaker(true)
        outCall?.begin()
        APIUtil.p2pCall(UserDefaults.standard.string(forKey: "userID")!, BUserID: callLog!.accountId) { verifyCodeInfo in
            
        }
        
        //        SwiftEventBus.onMainThread(self, name: "buddyOnline") { result in
        ////            self.buddyOnline()
        //        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkOnline(callLog!.accountId)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkOnline(_ accountId: String) {
        var b = true
        Async.background {
            var i = 0
            while !self.isHangup {
                
                Async.background(after:1.0) {
                    if i == 30 {
                        b = false
                        return
                    }
                    print("buddyIsOnline")
                    APIUtil.buddyIsOnline(accountId, callBack: { verifyCodeInfo in
                        i = i + 1
                        if verifyCodeInfo.codeStatus == 1 {
                            if verifyCodeInfo.codeInfo == "online" {
                                b = false
                                self.outCall?.begin()
                                return
                            }
                        }
                    })
                }.wait()
                if !b {
                    return
                }
            }
        }
    }
    
    //    func buddyOnline() {
    //        outCall?.begin()
    //    }
    
    @IBAction func hangup(_ sender: UIButton) {
        isHangup = true
        outCall?.end()
        newCallLog.accountId = callLog!.accountId
        newCallLog.contactId = callLog!.contactId
        newCallLog.name = callLog!.name
        newCallLog.phone = callLog!.phone
        if isConnected {
            newCallLog.callState = CallState.outConnected.rawValue
        } else {
            newCallLog.callState = CallState.outUnConnected.rawValue
        }
        newCallLog.callType = CallType.voice.rawValue
        newCallLog.area = callLog!.area
        try! App.realm.write {
            App.realm.add(newCallLog)
        }
        let callInfo = ["AuserID":UserDefaults.standard.string(forKey: "userID")!, "BUCID":newCallLog.accountId, "CallType":newCallLog.callType, "IncomingType":newCallLog.callState, "CallTime":newCallLog.callStartTime.description, "TalkTimeLength":"1000", "EndTime":newCallLog.callEndTime.description, "Area":newCallLog.area, "Name":newCallLog.name, "Mobile":newCallLog.phone] as [String : Any]
        APIUtil.saveCallLog(callInfo)
        SwiftEventBus.post("reloadCallLogs")
        App.changeSpeaker(false)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func speakerOnOff(_ sender: UIButton) {
        App.changeSpeaker(!App.isSpeakerOn)
    }
    
    func callStatusDidChange() {
        switch outCall!.status {
        case GSCallStatusReady:
            print("OutgoingCallViewController Ready.")
            break
            
        case GSCallStatusConnecting:
            print("OutgoingCallViewController Connecting...")
            break
            
        case GSCallStatusCalling:
            print("OutgoingCallViewController Calling...")
            
            break
            
        case GSCallStatusConnected:
            print("OutgoingCallViewController Connected.")
            areaLabel.start()
            isConnected = true
            dialPlateCon.isHidden = false
            speakerCon.isHidden = false
            
            break
            
        case GSCallStatusDisconnected:
            print("OutgoingCallViewController Disconnected.")
            areaLabel.pause()
            outCall?.end()
            dismiss(animated: true, completion: nil)
            break
            
        default:
            break
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            callStatusDidChange()
        }
    }
    
    deinit {
        outCall?.removeObserver(self, forKeyPath: "status")
        print("OutgoingCallViewController deinit")
    }
}
