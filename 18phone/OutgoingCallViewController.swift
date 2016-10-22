//
//  OutgoingCallViewController.swift
//  18phone
//
//  Created by 戴全艺 on 16/8/16.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit
import SwiftEventBus

class OutgoingCallViewController: UIViewController {

    var toNumber: String?
    var contactName: String?
    var phoneArea: String?
    var contactId: String?
    var outCall: GSCall?
    var isConnected: Bool = false
    
    /// 显示姓名或号码
    @IBOutlet weak var nameLabel: UILabel!
    
    /// 显示号码归属地
    @IBOutlet weak var areaLabel: UILabel!
    
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
        print("OutgoingCallViewController viewDidLoad")
        /**
         storyboard目前不支持设置CGColor
         */
        dialPlateBtn.layer.borderColor = UIColor.white.cgColor
        speakerBtn.layer.borderColor = UIColor.white.cgColor
        if !contactName!.isEmpty {
            nameLabel.text = contactName
        } else {
            nameLabel.text = toNumber
            areaLabel.text = phoneArea
        }
        
        let account = GSUserAgent.shared().account
        outCall = GSCall.outgoingCall(toUri: toNumber! + "@" + URL.BEYEBE_SIP_DOMAIN, from: account)
        outCall?.checkBuddy()
        outCall?.addObserver(self, forKeyPath: "status", options: .initial, context: nil)
        self.outCall?.begin()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func hangup(_ sender: UIButton) {
        outCall?.end()
        let callLog = CallLog()
        callLog.contactId = contactId!
        callLog.name = contactName!
        callLog.phone = toNumber!
        if isConnected {
            callLog.callState = CallState.outConnected.rawValue
        } else {
            callLog.callState = CallState.outUnConnected.rawValue
        }
        callLog.callType = CallType.voice.rawValue
        callLog.callStartTime = Date()
        if phoneArea != nil {
            callLog.area = phoneArea!
        }
        try! App.realm.write {
            App.realm.add(callLog)
        }
        SwiftEventBus.post("reloadCallLogs")
        dismiss(animated: true, completion: nil)
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
            isConnected = true
            dialPlateCon.isHidden = false
            speakerCon.isHidden = false
            break
            
        case GSCallStatusDisconnected:
            print("OutgoingCallViewController Disconnected.")
            
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
