//
//  IncomingVideoViewController.swift
//  18phone
//
//  Created by 戴全艺 on 16/8/25.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit

class IncomingVideoViewController: UIViewController {
    
    var inCall: GSCall?
    
    @IBOutlet weak var previewCon: UIView!
    
    @IBOutlet weak var renderCon: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inCall?.incomingCallInfo()
        inCall?.addObserver(self, forKeyPath: "status", options: .Initial, context: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        inCall?.startPreviewWindow()
        let previewWindow = inCall!.createPreviewWindow(CGRectMake(0, 0, previewCon.frame.width, previewCon.frame.height))
        previewCon.addSubview(previewWindow!)
        inCall?.orientation()
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
            videoView!.backgroundColor = UIColor.blueColor()
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
