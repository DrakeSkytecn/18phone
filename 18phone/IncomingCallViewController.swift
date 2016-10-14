//
//  IncomingCallViewController.swift
//  18phone
//
//  Created by 戴全艺 on 16/8/16.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit
import Contacts

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
        let phoneNumber = inCall?.incomingCallInfo()
        self.nameLabel.text = phoneNumber
        PhoneUtil.getPhoneAreaInfo(phoneNumber!) { phoneAreaInfo in
            if phoneAreaInfo.errNum == 0 {
                let tempArea = (phoneAreaInfo.retData?.province!)! + (phoneAreaInfo.retData?.city!)!
                self.areaLabel.text = tempArea
            } else {
                self.areaLabel.text = "未知归属地"
            }
            let store = CNContactStore()
            let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                               CNContactGivenNameKey,
                               CNContactFamilyNameKey,
                               CNContactPhoneNumbersKey] as [Any]
            let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor])
            try! store.enumerateContacts(with: fetchRequest) { (contact, stop) -> Void in
                for number in contact.phoneNumbers {
                    let tempNumber = (number.value).stringValue
                    if tempNumber == phoneNumber {
                        self.nameLabel.text = contact.familyName + contact.givenName
                        return
                    }
                }
            }
            
        }
        inCall?.addObserver(self, forKeyPath: "status", options: .initial, context: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func hangup(_ sender: UIButton) {
        inCall?.end()
        dismiss(animated: true, completion: nil)
    }

    @IBAction func answer(_ sender: UIButton) {
        self.inCall?.begin()
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
