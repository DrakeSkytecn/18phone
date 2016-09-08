//
//  OutgoingVideoViewController.swift
//  18phone
//
//  Created by 戴全艺 on 16/8/23.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit

class OutgoingVideoViewController: UIViewController {
    
    var toNumber: String?
    var outCall:GSCall?
    var isConnected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let account = GSUserAgent.sharedAgent().account
        outCall = GSCall.outgoingCallToUri(toNumber! + "@" + URL.BEYEBE_SIP_DOMAIN, fromAccount: account)
        let previewWindow = self.outCall?.createPreviewWindow()
        previewWindow?.frame = self.view.frame
        self.view.addSubview(previewWindow!)
        
        outCall?.addObserver(self, forKeyPath: "status", options: .Initial, context: nil)
        
        self.outCall?.begin()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func hangup(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
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
            outCall?.setOutgoingVideoStream()
            break
            
        case GSCallStatusDisconnected:
            print("OutgoingCallViewController Disconnected.")
            
            
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
    }
}