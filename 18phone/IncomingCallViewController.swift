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
        dialPlateBtn.layer.borderColor = UIColor.whiteColor().CGColor
        speakerBtn.layer.borderColor = UIColor.whiteColor().CGColor
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
            let keysToFetch = [CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName),
                               CNContactGivenNameKey,
                               CNContactFamilyNameKey,
                               CNContactPhoneNumbersKey]
            let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)
            try! store.enumerateContactsWithFetchRequest(fetchRequest) { (let contact, let stop) -> Void in
                for number in contact.phoneNumbers {
                    let tempNumber = (number.value as! CNPhoneNumber).stringValue
                    if tempNumber == phoneNumber {
                        self.nameLabel.text = contact.familyName + contact.givenName
                        return
                    }
                }
            }
            
        }
        inCall?.addObserver(self, forKeyPath: "status", options: .Initial, context: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func hangup(sender: UIButton) {
        inCall?.end()
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func answer(sender: UIButton) {
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
            connectingCon.hidden = true
            hangupCon.hidden = false
            dialPlateCon.hidden = false
            speakerCon.hidden = false
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
            dismissViewControllerAnimated(true, completion: nil)
            break
            
        default:
            break
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "status" {
            callStatusDidChange()
        }
    }
    
    deinit {
        inCall?.removeObserver(self, forKeyPath: "status")
        print("OutgoingCallViewController deinit")
    }

}
