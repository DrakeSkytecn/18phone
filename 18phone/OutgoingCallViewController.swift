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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let account = GSUserAgent.sharedAgent().account
        let call = GSCall.outgoingCallToUri(toNumber! + "@" + URL.BEYEBE_SIP_SERVER, fromAccount: account)
        let callLog = CallLog()
        callLog.name = "James"
        callLog.phone = toNumber!
        callLog.callState = 0
        callLog.callStartTime = DateUtil.getCurrentDate()
        if phoneArea != nil {
            callLog.area = phoneArea!
        }
        try! App.realm.write {
            App.realm.add(callLog)
        }
        Async.main(after: 1) {
            call.begin()
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func hangup(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
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
