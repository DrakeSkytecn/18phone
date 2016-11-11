//
//  IncomingVideoViewController.swift
//  18phone
//
//  Created by 戴全艺 on 16/8/25.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit
import Async

class IncomingVideoViewController: UIViewController {
    
    var inCall: GSCall?
    
    @IBOutlet weak var previewCon: UIView!
    
    @IBOutlet weak var renderCon: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inCall?.videoCon = previewCon
//        inCall?.incomingCallInfo()
        inCall?.addObserver(self, forKeyPath: "status", options: .initial, context: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
//        Async.background {
//            self.inCall?.startPreviewWindow()
//            }.main { _ in
//                let previewWindow = self.inCall!.createPreviewWindow(CGRect(x: 0, y: 0, width: self.previewCon.frame.width, height: self.previewCon.frame.height))
//                self.previewCon.addSubview(previewWindow!)
//                self.inCall?.orientation()
//        }
        
//        inCall?.startPreviewWindow()
//        let previewWindow = inCall!.createPreviewWindow(CGRect(x: 0, y: 0, width: previewCon.frame.width, height: previewCon.frame.height))
//        previewCon.addSubview(previewWindow!)
//        inCall?.orientation()
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
        inCall?.beginVideo()
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
            let videoView = inCall!.createVideoWindow(view.frame)
            videoView!.backgroundColor = UIColor.blue
            renderCon.addSubview(videoView!)
            inCall?.orientation()
            
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
        inCall?.stopPreviewWindow()
        inCall?.removeObserver(self, forKeyPath: "status")
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
