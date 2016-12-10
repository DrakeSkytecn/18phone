//
//  OutgoingVideoViewController.swift
//  18phone
//
//  Created by 戴全艺 on 16/8/23.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit
import Async
import SwiftEventBus

class OutgoingVideoViewController: UIViewController {
    
    var callLog: CallLog?
    
    let newCallLog = CallLog()
    
    var outCall:GSCall?
    
    var isHangup = false
    
    var isConnected: Bool = false
    
    @IBOutlet weak var videoWidth: NSLayoutConstraint!
    
    @IBOutlet weak var renderCon: UIView!
    
    @IBOutlet weak var previewCon: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var areaLabel: MZTimerLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !callLog!.name.isEmpty {
            nameLabel.text = callLog!.name
            areaLabel.text = "正在拨打视频"
        } else {
            nameLabel.text = callLog!.phone
            areaLabel.text = callLog!.area
        }
        let account = GSUserAgent.shared().account
        outCall = GSCall.outgoingCall(toUri: callLog!.accountId + "@" + AppURL.BEYEBE_SIP_DOMAIN, from: account)
        outCall?.addObserver(self, forKeyPath: "status", options: .initial, context: nil)
        APIUtil.p2pCall(UserDefaults.standard.string(forKey: "userID")!, BUserID: callLog!.accountId) { verifyCodeInfo in
            
        }
        App.changeSpeaker(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        Async.background {
//            self.outCall?.startPreviewWindow()
//        }.main { _ in
//            let previewWindow = self.outCall!.createPreviewWindow(CGRect(x: 0, y: 0, width: 40, height: 80))
//            previewWindow?.backgroundColor = UIColor.blue
//            self.previewCon.addSubview(previewWindow!)
//            self.outCall?.orientation()
//        }
        checkOnline(callLog!.accountId)
    }
    
    func checkOnline(_ accountId: String) {
        var b = true
        Async.background {
            var i = 0
            while !self.isHangup {
                Async.background(after:1.0) {
                    if i == 60 {
                        b = false
                        Async.main {
                            self.areaLabel.text = "暂时无法接通，请稍后再拨"
                        }
                        return
                    }
                    APIUtil.buddyIsOnline(accountId, callBack: { verifyCodeInfo in
                        i = i + 1
                        if verifyCodeInfo.codeStatus == 1 {
                            if verifyCodeInfo.codeInfo == "online" {
                                b = false
                                self.outCall?.beginVideo()
                                self.outCall?.startPreviewWindow()
                                let previewWindow = self.outCall!.createPreviewWindow(CGRect(x: 0, y: 0, width: self.previewCon.frame.width, height: self.previewCon.frame.height))
                                self.previewCon.addSubview(previewWindow!)
                                self.outCall?.orientation()
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func big(_ sender: UIButton) {
//        videoWidth.constant = 400
//        previewCon.subviews[0].backgroundColor = UIColor.blue
        previewCon.subviews[0].frame = CGRect(x: -20, y: 20, width: 81, height: 121)
    }
    
    @IBAction func hangup(_ sender: UIButton) {
        isHangup = true
        outCall?.stopPreviewWindow()
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
        newCallLog.callType = CallType.video.rawValue
        newCallLog.area = callLog!.area
        newCallLog.callEndTime = Date()
        try! App.realm.write {
            App.realm.add(newCallLog)
        }
        SwiftEventBus.post("reloadCallLogs")
        App.changeSpeaker(false)
        dismiss(animated: true, completion: {
            let callInfo = ["AuserID":UserDefaults.standard.string(forKey: "userID")!, "BUCID":self.newCallLog.accountId, "CallType":self.newCallLog.callType, "IncomingType":self.newCallLog.callState, "CallTime":self.newCallLog.callStartTime.description, "TalkTimeLength":"1000", "EndTime":self.newCallLog.callEndTime.description, "Area":self.newCallLog.area, "Name":self.newCallLog.name, "Mobile":self.newCallLog.phone] as [String : Any]
            APIUtil.saveCallLog(callInfo)
        })
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
            let videoView = outCall!.createVideoWindow(view.frame)
            renderCon.addSubview(videoView!)
            outCall?.orientation()
            
            break
            
        case GSCallStatusDisconnected:
            print("OutgoingCallViewController Disconnected.")
            areaLabel.pause()
            areaLabel.text = "通话已挂断"
//            dismiss(animated: true, completion: nil)
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
        outCall?.stopPreviewWindow()
        outCall?.removeObserver(self, forKeyPath: "status")
    }
}
