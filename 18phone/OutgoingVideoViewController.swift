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
    
    var callLog: CallLog?
    
    let newCallLog = CallLog()
    
    var outCall:GSCall?
    
    var isConnected: Bool = false
    
    @IBOutlet weak var videoWidth: NSLayoutConstraint!
    
    @IBOutlet weak var renderCon: UIView!
    
    @IBOutlet weak var previewCon: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var areaLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !callLog!.name.isEmpty {
            nameLabel.text = callLog!.name
        } else {
            nameLabel.text = callLog!.phone
            areaLabel.text = callLog!.area
        }
        let account = GSUserAgent.shared().account
        outCall = GSCall.outgoingCall(toUri: callLog!.accountId + "@" + AppURL.BEYEBE_SIP_DOMAIN, from: account)
        outCall?.addObserver(self, forKeyPath: "status", options: .initial, context: nil)
        outCall?.beginVideo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        Async.background {
//            self.outCall?.startPreviewWindow()
//        }.main { _ in
//            let previewWindow = self.outCall!.createPreviewWindow(CGRect(x: 0, y: 0, width: 40, height: 80))
//            previewWindow?.backgroundColor = UIColor.blue
//            self.previewCon.addSubview(previewWindow!)
//            self.outCall?.orientation()
//        }
        self.outCall?.startPreviewWindow()
        let previewWindow = self.outCall!.createPreviewWindow(CGRect(x: 0, y: 0, width: previewCon.frame.width, height: previewCon.frame.height))
        self.previewCon.addSubview(previewWindow!)
        self.outCall?.orientation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func big(_ sender: UIButton) {
//        videoWidth.constant = 400
//        previewCon.subviews[0].backgroundColor = UIColor.blue
        previewCon.subviews[0].frame = CGRect(x: -20, y: 20, width: 81, height: 121)
    }
    
    @IBAction func hangup(_ sender: UIButton) {
        outCall?.stopPreviewWindow()
        outCall?.end()
        newCallLog.accountId = callLog!.accountId
        newCallLog.contactId = callLog!.contactId
        newCallLog.name = callLog!.name
        newCallLog.phone = callLog!.phone
        if isConnected {
            newCallLog.callState = CallState.outConnected.rawValue
        } else {
            newCallLog.callState = CallState.outUnConnected.rawValue
        }
        newCallLog.callType = CallType.video.rawValue
        newCallLog.area = callLog!.area
        try! App.realm.write {
            App.realm.add(newCallLog)
        }
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
