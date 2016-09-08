//
//  OutgoingCallViewController.swift
//  18phone
//
//  Created by 戴全艺 on 16/8/16.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit

class OutgoingCallViewController: UIViewController {

    var toNumber: String?
    var contactName: String?
    var phoneArea: String?
    var outCall:GSCall?
    var isConnected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("OutgoingCallViewController viewDidLoad")
        let account = GSUserAgent.sharedAgent().account
        outCall = GSCall.outgoingCallToUri(toNumber! + "@" + URL.BEYEBE_SIP_DOMAIN, fromAccount: account)
        outCall?.addObserver(self, forKeyPath: "status", options: .Initial, context: nil)
        Async.main(after: 1) {
            self.outCall?.begin()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func hangup(sender: UIButton) {
        outCall?.end()
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
            break
            
        case GSCallStatusDisconnected:
            print("OutgoingCallViewController Disconnected.")
            let callLog = CallLog()
            callLog.name = "James"
            callLog.phone = toNumber!
            if isConnected {
                callLog.callState = CallState.OutConnected.rawValue
            } else {
                callLog.callState = CallState.OutUnConnected.rawValue
            }
            callLog.callType = 0
            callLog.callStartTime = DateUtil.getCurrentDate()
            if phoneArea != nil {
                callLog.area = phoneArea!
            }
            try! App.realm.write {
                App.realm.add(callLog)
            }
            SwiftEventBus.post("reloadCallLogs")
            
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
        outCall?.removeObserver(self, forKeyPath: "status")
        print("OutgoingCallViewController deinit")
    }
}
