//
//  OutgoingVideoViewController.swift
//  18phone
//
//  Created by 戴全艺 on 16/8/23.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit
import Async

class OutgoingVideoViewController: UIViewController {
    
    var toNumber: String?
    var outCall:GSCall?
    var isConnected: Bool = false
    
    @IBOutlet weak var renderCon: UIView!
    
    @IBOutlet weak var previewCon: UIView!
    
    @IBOutlet weak var NameLabel: UILabel!
    
    @IBOutlet weak var areaLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let account = GSUserAgent.shared().account
        outCall = GSCall.outgoingCall(toUri: toNumber! + "@" + URL.BEYEBE_SIP_DOMAIN, from: account)
        outCall?.addObserver(self, forKeyPath: "status", options: .initial, context: nil)
        outCall?.beginVideo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Async.background {
            self.outCall?.startPreviewWindow()
        }.main { _ in
            let previewWindow = self.outCall!.createPreviewWindow(CGRect(x: 0, y: 0, width: self.previewCon.frame.width, height: self.previewCon.frame.height))
            self.previewCon.addSubview(previewWindow!)
            self.outCall?.orientation()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func hangup(_ sender: UIButton) {
        outCall?.stopPreviewWindow()
        outCall?.end()
        dismiss(animated: true, completion: nil)
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
            let videoView = outCall!.createVideoWindow(view.frame)
            videoView!.backgroundColor = UIColor.blue
            renderCon.addSubview(videoView!)
            outCall?.orientation()
            
            break
            
        case GSCallStatusDisconnected:
            print("OutgoingCallViewController Disconnected.")
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
