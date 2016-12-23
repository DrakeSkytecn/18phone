//
//  OutgoingCallViewController.swift
//  18phone
//
//  Created by 戴全艺 on 16/8/16.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

class OutgoingCallViewController: UIViewController {
    
    var dialLine: DialLine = .p2p
    
    var callLog: CallLog?
    
    var outCall: GSCall?
    
    var isHangup = false
    
    var isConnected = false
    
    let newCallLog = CallLog()
    
    var checkOnlineLoop: Async?
    
    var callDuration = ""
    
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
        areaLabel.text = "正在拨号"
        if !callLog!.name.isEmpty {
            nameLabel.text = callLog!.name
        } else {
            nameLabel.text = callLog!.phone
            areaLabel.text = callLog!.area
        }
        App.ulinkService.setHandfree(true)
//        App.changeSpeaker(true)
        App.ulinkService.playP2PRing("ringtone", soundType: "wav")
        SwiftEventBus.onMainThread(self, name: "talking") { result in
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            self.areaLabel.start()
            self.isConnected = true
            self.dialPlateCon.isHidden = false
            self.speakerCon.isHidden = false
        }
        SwiftEventBus.onMainThread(self, name: "callStop") { result in
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            self.areaLabel.pause()
            if self.isConnected && self.callDuration.isEmpty {
                self.callDuration = self.areaLabel.text!
            }
            self.areaLabel.text = "通话已挂断"
        }
        SwiftEventBus.onMainThread(self, name: "noAnswer") { result in
            App.ulinkService.stopP2PRingOrRingback()
            self.areaLabel.text = "暂时无法接通，请稍后再拨"
        }
        if dialLine == .p2p {
            APIUtil.p2pCall(UserDefaults.standard.string(forKey: "userID")!, BUserID: self.callLog!.accountId) { verifyCodeInfo in
                
            }
            self.checkOnline(self.callLog!.accountId)
//            SwiftEventBus.onMainThread(self, name: "offline") { result in
//                
//            }
//            let account = GSUserAgent.shared().account
//            outCall = GSCall.outgoingCall(toUri: callLog!.accountId + "@" + AppURL.BEYEBE_SIP_DOMAIN, from: account)
//            outCall?.addObserver(self, forKeyPath: "status", options: .initial, context: nil)

//            outCall?.begin()
        } else if dialLine == .direct {
            App.ulinkService.sendCallInvite("", toPhone: callLog!.phone, display: UserDefaults.standard.string(forKey: "username")!, attData: "")
        }
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        if dialLine == .p2p {
//            checkOnline(callLog!.accountId)
//        }
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkOnline(_ accountId: String) {
        var b = true
        Async.background { [weak self] in
            var i = 0
                while self != nil && !self!.isHangup {
                    Async.background(after:1.0) {
                        if i == 60 {
                            b = false
                            Async.main {
                                self!.areaLabel.text = "暂时无法接通，请稍后再拨"
                            }
                            return
                        }
                        APIUtil.buddyIsOnline(accountId, callBack: { verifyCodeInfo in
                            i = i + 1
                            if verifyCodeInfo.codeStatus == 1 {
                                if verifyCodeInfo.codeInfo == "online" {
                                    b = false
                                    App.ulinkService.sendCallInvite(App.ULINK_DEV_ID + "#" + App.ULINK_APP_ID + "#" + self!.callLog!.clientNumber , toPhone: self!.callLog!.phone, display: self!.callLog!.phone, attData: UserDefaults.standard.string(forKey: "userID"))
//                                    self!.outCall?.begin()
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
    
    @IBAction func hangup(_ sender: UIButton) {
        App.ulinkService.stopP2PRingOrRingback()
        isHangup = true
        App.ulinkService.setHandfree(false)
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        if dialLine == .p2p {
            App.ulinkService.sendCallBye()
//            outCall?.end()
        } else {
            App.ulinkService.sendCallBye()
        }
        addCallLog()
//        App.changeSpeaker(false)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func speakerOnOff(_ sender: UIButton) {
        App.ulinkService.setHandfree(!App.ulinkService.getHandfreeValue())
//        App.changeSpeaker(!App.isSpeakerOn)
    }
    
    func addCallLog() {
        newCallLog.accountId = callLog!.accountId
        newCallLog.clientNumber = callLog!.clientNumber
        newCallLog.contactId = callLog!.contactId
        newCallLog.headPhoto = callLog!.headPhoto
        newCallLog.name = callLog!.name
        newCallLog.phone = callLog!.phone
        newCallLog.callDuration = callDuration
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
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            areaLabel.start()
            isConnected = true
            dialPlateCon.isHidden = false
            speakerCon.isHidden = false
            break
            
        case GSCallStatusDisconnected:
            print("OutgoingCallViewController Disconnected.")
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            areaLabel.pause()
            if isConnected && callDuration.isEmpty {
                callDuration = areaLabel.text!
            }
            areaLabel.text = "通话已挂断"
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
        if dialLine == .p2p {
//            outCall?.removeObserver(self, forKeyPath: "status")
        } else {
            SwiftEventBus.unregister(self)
        }
        print("OutgoingCallViewController deinit")
    }
}
