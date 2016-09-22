//
//  CallLogMenuViewController.swift
//  18phone
//
//  Created by 戴全艺 on 16/9/22.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit
import RealmSwift

class CallLogMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var contactId: String?
    
    var callLogs: Results<CallLog>?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        callLogs = App.realm.objects(CallLog.self).filter("identifier == '\(contactId!)'")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadCallLogs() {
        callLogs = App.realm.objects(CallLog.self).filter("identifier == '\(contactId!)'")
        tableView.reloadData()
    }
    
    @IBAction func clearAllCallLog(sender: UIButton) {
        if callLogs!.count != 0 {
            let alertController = UIAlertController(title: "清空通话记录", message: "此操作不可撤回，确认清除所有的通话记录吗？", preferredStyle: .ActionSheet)
            alertController.addAction(UIAlertAction(title: "确认", style: .Destructive) { action in
                try! App.realm.write {
                    App.realm.delete(self.callLogs!)
                }
                self.reloadCallLogs()
                SwiftEventBus.post("reloadCallLogs")
                })
            alertController.addAction(UIAlertAction(title: "取消", style: .Cancel) { action in
                
                })
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return callLogs!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let callLog = callLogs![indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.detail_log_cell)
        if callLog.callType == CallType.Voice.rawValue {
            cell!.callType.image = R.image.voice_call()
        } else {
            cell!.callType.image = R.image.video_call()
        }
        cell?.callStartTime.text = DateUtil.dateToString(callLog.callStartTime)
        switch callLog.callState {
        case CallState.InUnConnected.rawValue:
            cell!.callState.image = R.image.call_in_unconnected()
            break
        case CallState.InConnected.rawValue:
            cell!.callState.image = R.image.call_in_connected()
            break
        case CallState.OutUnConnected.rawValue:
            cell!.callState.image = R.image.call_out_unconnected()
            break
        case CallState.OutConnected.rawValue:
            cell!.callState.image = R.image.call_out_connected()
            break
        default:
            break
        }
        //cell?.callDuration = callLog.callDuration
        
        return cell!
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
