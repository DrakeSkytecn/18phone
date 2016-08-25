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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Async.main(after: 1) {
            self.inCall?.begin()
            let videoView = self.inCall?.createVideoWindow()
            print("inCall?.callId", self.inCall?.callId)
            videoView?.frame = self.view.frame
            self.view.addSubview(videoView!)
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
