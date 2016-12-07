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
import SwiftEventBus

class IncomingCallViewController: UIViewController {

    var accountId = ""
    
    var appContactInfo: AppContactInfo?
    
    var phoneNumber = ""
    
    var isConnected: Bool = false
    
    var inCall: GSCall?
    
    /// 接通前显示来电信息，接通后显示通话时间
    @IBOutlet weak var nameLabel: UILabel!
    
    /// 接通前显示来电信息，接通后显示通话时间
    @IBOutlet weak var areaLabel: MZTimerLabel!
    
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
        accountId = inCall!.incomingCallInfo()!
        appContactInfo = App.realm.objects(AppContactInfo.self).filter("accountId == '\(accountId)'").first
        if appContactInfo == nil {
            APIUtil.getUserInfo(accountId, callBack: { userInfo in
                if userInfo.codeStatus == 1 {
                    let store = CNContactStore()
                    let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                                       CNContactGivenNameKey,
                                       CNContactFamilyNameKey,
                                       CNContactPhoneNumbersKey] as [Any]
                    let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor])
                    try! store.enumerateContacts(with: fetchRequest) { contact, stop in
                        for number in contact.phoneNumbers {
                            let formatNumber = PhoneUtil.formatPhoneNumber((number.value).stringValue)
                            if formatNumber == userInfo.userData!.mobile! {
                                self.phoneNumber = formatNumber
                                self.nameLabel.text = contact.familyName + contact.givenName
                                self.appContactInfo = App.realm.objects(AppContactInfo.self).filter("identifier == '\(contact.identifier)'").first
                                try! App.realm.write {
                                    self.appContactInfo?.accountId = self.accountId
                                    self.appContactInfo?.isRegister = true
                                }
                                PhoneUtil.getPhoneAreaInfo(formatNumber, callBack: { phoneAreaInfo in
                                    if phoneAreaInfo.errNum == 0 {
                                        let province = phoneAreaInfo.retData!.province!
                                        let city = phoneAreaInfo.retData!.city!
                                        let fullArea = province + city
                                        switch province {
                                        case "北京", "上海", "天津", "重庆":
                                            try! App.realm.write {
                                                self.appContactInfo?.area = province
                                            }
                                            break
                                        default:
                                            try! App.realm.write {
                                                self.appContactInfo?.area = fullArea
                                            }
                                            break
                                        }
                                    }
                                })
                            }
                        }
                    }
                    if self.nameLabel.text!.isEmpty {
                        self.nameLabel.text = userInfo.userData?.mobile
                        self.areaLabel.text = userInfo.userData?.provinceCity
                    }
                }
            })
        } else {
            let store = CNContactStore()
            let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                               CNContactGivenNameKey,
                               CNContactFamilyNameKey,
                               CNContactPhoneNumbersKey] as [Any]
            do {
                let contact = try store.unifiedContact(withIdentifier: appContactInfo!.identifier, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                self.nameLabel.text = contact.familyName + contact.givenName
                for (i, item) in contact.phoneNumbers.enumerated() {
                    if i == 0 {
                        phoneNumber = PhoneUtil.formatPhoneNumber(item.value.stringValue)
                        PhoneUtil.getPhoneAreaInfo(phoneNumber, callBack: { phoneAreaInfo in
                            if phoneAreaInfo.errNum == 0 {
                                let province = phoneAreaInfo.retData!.province!
                                let city = phoneAreaInfo.retData!.city!
                                let fullArea = province + city
                                switch province {
                                case "北京", "上海", "天津", "重庆":
                                    try! App.realm.write {
                                        self.appContactInfo?.area = province
                                    }
                                    break
                                default:
                                    try! App.realm.write {
                                        self.appContactInfo?.area = fullArea
                                    }
                                    break
                                }
                            }
                        })
                    }
                }
            } catch {
                
            }
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
    
    func addCallLog() {
        let callLog = CallLog()
        callLog.accountId = accountId
        callLog.contactId = appContactInfo!.identifier
        if areaLabel.text!.isEmpty {
            callLog.name = nameLabel.text!
        }
        callLog.phone = phoneNumber
        if isConnected {
            callLog.callState = CallState.inConnected.rawValue
        } else {
            callLog.callState = CallState.inUnConnected.rawValue
        }
        callLog.callType = CallType.voice.rawValue
        callLog.area = appContactInfo!.area
        try! App.realm.write {
            App.realm.add(callLog)
        }
        let callInfo = ["AuserID":UserDefaults.standard.string(forKey: "userID")!, "BUCID":callLog.accountId, "CallType":callLog.callType, "IncomingType":callLog.callState, "CallTime":callLog.callStartTime.description, "TalkTimeLength":"1000", "EndTime":callLog.callEndTime.description, "Area":callLog.area, "Name":callLog.name, "Mobile":callLog.phone] as [String : Any]
        APIUtil.saveCallLog(callInfo)
        SwiftEventBus.post("reloadCallLogs")
    }
    
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
            areaLabel.start()
            isConnected = true
            connectingCon.isHidden = true
            hangupCon.isHidden = false
            dialPlateCon.isHidden = false
            speakerCon.isHidden = false
            break
            
        case GSCallStatusDisconnected:
            print("IncomingCallViewController Disconnected.")
            areaLabel.pause()
            addCallLog()
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
        inCall?.removeObserver(self, forKeyPath: "status")
        print("OutgoingCallViewController deinit")
    }

}
