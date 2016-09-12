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
    
    @IBOutlet weak var videoCon: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inCall?.addObserver(self, forKeyPath: "status", options: .Initial, context: nil)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func hangup(sender: UIButton) {
        inCall?.end()
    }
    
    @IBAction func answer(sender: UIButton) {
        inCall?.begin()
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
            //inCall?.setIncomingVideoStream()
            let videoView = self.inCall?.createVideoWindow()
            videoView?.frame = self.view.frame
            videoCon.addSubview(videoView!)

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
