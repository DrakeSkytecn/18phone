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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let account = GSUserAgent.sharedAgent().account
        outCall = GSCall.outgoingCallToUri(toNumber! + "@" + URL.BEYEBE_SIP_DOMAIN, fromAccount: account)
        self.outCall?.begin()
        let previewWindow = self.outCall?.createPreviewWindow()
        previewWindow?.frame = self.view.frame
        self.view.addSubview(previewWindow!)
        
        //outCall?.addObserver(self, forKeyPath: "status", options: .Initial, context: nil)
        
        
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
