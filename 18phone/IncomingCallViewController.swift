//
//  IncomingCallViewController.swift
//  18phone
//
//  Created by 戴全艺 on 16/8/16.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit
import Contacts
import AVFoundation

class IncomingCallViewController: UIViewController {

    var inCall: GSCall?
    
    var isConnected: Bool = false
    
    /// 接通前显示来电信息，接通后显示通话时间
    @IBOutlet weak var nameLabel: UILabel!
    
    /// 接通前显示来电信息，接通后显示通话时间
    @IBOutlet weak var areaLabel: UILabel!
    
    /// 接通前按钮容器
    @IBOutlet weak var connectingCon: UIView!
    
    /// 挂断按钮容器
    @IBOutlet weak var hangupCon: UIView!
    
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
        let accountId = inCall?.incomingCallInfo()
        var appContactInfo = App.realm.objects(AppContactInfo.self).filter("accountId == '\(accountId!)'").first
        if appContactInfo == nil {
            APIUtil.getUserInfo(accountId!, callBack: { userInfo in
                if userInfo.codeStatus == 1 {
                    let store = CNContactStore()
                    let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                                       CNContactGivenNameKey,
                                       CNContactFamilyNameKey,
                                       CNContactPhoneNumbersKey] as [Any]
                    let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor])
                    try! store.enumerateContacts(with: fetchRequest) { contact, stop -> Void in
                        for number in contact.phoneNumbers {
                            let phoneNumber = PhoneUtil.formatPhoneNumber((number.value).stringValue)
                            if phoneNumber == userInfo.userData!.mobile! {
                                self.nameLabel.text = contact.familyName + contact.givenName
                                appContactInfo = App.realm.objects(AppContactInfo.self).filter("identifier == '\(contact.identifier)'").first
                                try! App.realm.write {
                                    appContactInfo?.accountId = accountId!
                                    appContactInfo?.isRegister = true
                                }
                            }
                        }
                    }
//                    if self.nameLabel.text!.isEmpty {
//                        self.nameLabel.text =
//                    }
                }
            })
        } else {
            let store = CNContactStore()
            let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                               CNContactGivenNameKey,
                               CNContactFamilyNameKey,
                               CNContactPhoneNumbersKey] as [Any]
            let contact = try! store.unifiedContact(withIdentifier: appContactInfo!.identifier, keysToFetch: keysToFetch as! [CNKeyDescriptor])
            self.nameLabel.text = contact.familyName + contact.givenName
        }
        inCall?.addObserver(self, forKeyPath: "status", options: .initial, context: nil)
//        inCall?.startRingback()
        App.changeSpeaker(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func hangup(_ sender: UIButton) {
        App.changeSpeaker(false)
        inCall?.end()
        dismiss(animated: true, completion: nil)
    }

    @IBAction func answer(_ sender: UIButton) {
        self.inCall?.begin()
    }
    
    @IBAction func speakerOnOff(_ sender: UIButton) {
        App.changeSpeaker(!App.isSpeakerOn)
    }
    
//    func changeSpeaker(_ isOn: Bool) {
//        let port = isOn ? AVAudioSessionPortOverride.speaker : AVAudioSessionPortOverride.none
//        isSpeakerOn = isOn
//        try! AVAudioSession.sharedInstance().overrideOutputAudioPort(port)
//    }
    
    func callStatusDidChange() {
        switch inCall!.status {
        case GSCallStatusReady:
            print("IncomingCallViewController Ready.")
            break
            
        case GSCallStatusConnecting:
            print("IncomingCallViewController Connecting...")
            break
            
        case GSCallStatusCalling:
            print("IncomingCallViewController Calling...")
            break
            
        case GSCallStatusConnected:
            print("IncomingCallViewController Connected.")
            isConnected = true
            connectingCon.isHidden = true
            hangupCon.isHidden = false
            dialPlateCon.isHidden = false
            speakerCon.isHidden = false
            break
            
        case GSCallStatusDisconnected:
            print("IncomingCallViewController Disconnected.")
//            let callLog = CallLog()
//            callLog.name = "James"
//            callLog.phone = toNumber!
//            callLog.callState = 0
//            callLog.callType = 0
//            callLog.callStartTime = DateUtil.getCurrentDate()
//            if phoneArea != nil {
//                callLog.area = phoneArea!
//            }
//            try! App.realm.write {
//                App.realm.add(callLog)
//            }
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
        inCall?.removeObserver(self, forKeyPath: "status")
        print("OutgoingCallViewController deinit")
    }

}
