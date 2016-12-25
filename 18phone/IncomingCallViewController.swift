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

    var accountId = ""
    
    var appContactInfo: AppContactInfo?
    
    var phoneNumber = ""
    
    var isConnected: Bool = false
    
    var inCall: GSCall?
    
    var callDuration = ""
    
    let callLog = CallLog()
    
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
        App.ulinkService.setHandfree(true)
//        App.changeSpeaker(true)
        /**
         storyboard目前不支持设置CGColor
         */
        dialPlateBtn.layer.borderColor = UIColor.white.cgColor
        speakerBtn.layer.borderColor = UIColor.white.cgColor
        SwiftEventBus.onMainThread(self, name: "talking") { result in
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            self.areaLabel.start()
            self.isConnected = true
            self.connectingCon.isHidden = true
            self.hangupCon.isHidden = false
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
            self.areaLabel.text = "暂时无法接通，请稍后再拨"
        }
//        accountId = inCall!.incomingCallInfo()!
        appContactInfo = App.realm.objects(AppContactInfo.self).filter("accountId == '\(accountId)'").first
        if appContactInfo == nil {
            APIUtil.getUserInfo(accountId, callBack: { userInfo in
                if userInfo.codeStatus == 1 {
                    self.phoneNumber = userInfo.userData!.mobile!
                    self.nameLabel.text = self.phoneNumber
                    PhoneUtil.getPhoneAreaInfo(self.phoneNumber, callBack: { phoneAreaInfo in
                        if phoneAreaInfo.errNum == 0 {
                            if phoneAreaInfo.retData!.province != nil {
                                let province = phoneAreaInfo.retData!.province!
                                let city = phoneAreaInfo.retData!.city!
                                let fullArea = province + city
                                switch province {
                                case "北京", "上海", "天津", "重庆":
                                    self.areaLabel.text = province
                                    self.callLog.area = province
                                    break
                                default:
                                    self.areaLabel.text = fullArea
                                    self.callLog.area = fullArea
                                    break
                                }
                            }
                        }
                    })
//                    let store = CNContactStore()
//                    let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
//                                       CNContactGivenNameKey,
//                                       CNContactFamilyNameKey,
//                                       CNContactPhoneNumbersKey] as [Any]
//                    let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor])
//                    try! store.enumerateContacts(with: fetchRequest) { contact, stop in
//                        for number in contact.phoneNumbers {
//                            let formatNumber = PhoneUtil.formatPhoneNumber((number.value).stringValue)
//                            if formatNumber == self.phoneNumber {
//                                self.nameLabel.text = contact.familyName + contact.givenName
//                                self.callLog.name = self.nameLabel.text!
//                                self.appContactInfo = App.realm.objects(AppContactInfo.self).filter("identifier == '\(contact.identifier)'").first
//                                try! App.realm.write {
//                                    self.appContactInfo?.accountId = self.accountId
//                                    self.appContactInfo?.isRegister = true
//                                }
                    
//                            }
//                        }
//                    }
//                    if self.nameLabel.text!.isEmpty {
//                        self.nameLabel.text = userInfo.userData?.mobile
//                        self.areaLabel.text = userInfo.userData?.provinceCity
//                    }
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
                self.callLog.name = self.nameLabel.text!
                for (i, item) in contact.phoneNumbers.enumerated() {
                    if i == 0 {
                        phoneNumber = PhoneUtil.formatPhoneNumber(item.value.stringValue)
                        PhoneUtil.getPhoneAreaInfo(phoneNumber, callBack: { phoneAreaInfo in
                            if phoneAreaInfo.errNum == 0 {
                                if phoneAreaInfo.retData!.province != nil {
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
                            }
                        })
                    }
                }
            } catch {
                
            }
        }
        
//        inCall?.addObserver(self, forKeyPath: "status", options: .initial, context: nil)
//        inCall?.startRingback()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func hangup(_ sender: UIButton) {
        App.ulinkService.setHandfree(false)
//        App.changeSpeaker(false)
//        inCall?.end()
        App.ulinkService.sendCallBye()
        addCallLog()
        dismiss(animated: true, completion: nil)
    }

    @IBAction func answer(_ sender: UIButton) {
        App.ulinkService.sendCallAnswer()
//        inCall?.begin()
    }
    
    @IBAction func speakerOnOff(_ sender: UIButton) {
        App.ulinkService.setHandfree(!App.ulinkService.getHandfreeValue())
//        App.changeSpeaker(!App.isSpeakerOn)
    }
    
    func addCallLog() {
        callLog.accountId = accountId
        if appContactInfo != nil {
            callLog.clientNumber = appContactInfo!.clientNumber
            callLog.contactId = appContactInfo!.identifier
            callLog.area = appContactInfo!.area
        }
        callLog.phone = phoneNumber
        callLog.callDuration = callDuration
        if isConnected {
            callLog.callState = CallState.inConnected.rawValue
        } else {
            callLog.callState = CallState.inUnConnected.rawValue
        }
        callLog.callType = CallType.voice.rawValue
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
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            areaLabel.start()
            isConnected = true
            connectingCon.isHidden = true
            hangupCon.isHidden = false
            dialPlateCon.isHidden = false
            speakerCon.isHidden = false
            break
            
        case GSCallStatusDisconnected:
            print("IncomingCallViewController Disconnected.")
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
//        inCall?.removeObserver(self, forKeyPath: "status")
        print("OutgoingCallViewController deinit")
    }

}
