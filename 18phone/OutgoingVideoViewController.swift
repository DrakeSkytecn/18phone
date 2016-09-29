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
    
    @IBOutlet weak var previewCon: UIView!
    
    @IBOutlet weak var NameLabel: UILabel!
    
    @IBOutlet weak var areaLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let account = GSUserAgent.sharedAgent().account
        outCall = GSCall.outgoingCallToUri(toNumber! + "@" + URL.BEYEBE_SIP_DOMAIN, fromAccount: account)
        outCall?.addObserver(self, forKeyPath: "status", options: .Initial, context: nil)
        outCall?.beginVideo()
    }
    
    override func viewDidAppear(animated: Bool) {
        var previewWindow: UIView? = nil
        Async.background {
            previewWindow = self.outCall!.createPreviewWindow(CGRectMake(0, 0, Screen.width, Screen.height))
            previewWindow?.performSelectorOnMainThread(<#T##aSelector: Selector##Selector#>, withObject: <#T##AnyObject?#>, waitUntilDone: <#T##Bool#>)
            }.main {
                
                previewWindow!.frame = CGRectMake(0, 0, Screen.width, Screen.height)
                previewWindow?.backgroundColor = UIColor.blueColor()
                print(previewWindow?.classForCoder.description())
                print(previewWindow?.layer.frame.origin.x)
                print(previewWindow?.layer.frame.origin.y)
                print(previewWindow?.layer.frame.size.width)
                print(previewWindow?.layer.frame.size.height)
                self.previewCon.addSubview(previewWindow!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func hangup(sender: UIButton) {
        self.outCall?.end()
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
            
            break
            
        case GSCallStatusDisconnected:
            print("OutgoingCallViewController Disconnected.")
            
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