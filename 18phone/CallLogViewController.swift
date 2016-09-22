//
//  CallLogViewController.swift
//  bottompopmenu
//
//  Created by 戴全艺 on 16/7/27.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit
import RealmSwift

class CallLogViewController: UITableViewController {
    
    var callLogs: Results<CallLog>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callLogs = App.realm.objects(CallLog.self).sorted("callStartTime", ascending: false)
        tableView.tableFooterView = UIView()
        SwiftEventBus.onMainThread(self, name: "reloadCallLogs") { result in
            self.reloadCallLogs()
        }
        SwiftEventBus.onMainThread(self, name: "deleteAllCallLogs") { result in
            self.deleteAllCallLogs()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func scrollsToTopEnable(enable: Bool) {
        tableView.scrollsToTop = enable
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return callLogs!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.log_a)
        let callLog = callLogs![indexPath.row]
        
        if callLog.name.isEmpty {
            cell!.phoneName.text = callLog.phone
            cell!.name.text = nil
            cell!.phone.text = nil
        } else {
            cell!.phoneName.text = nil
            cell!.name.text = callLog.name
            cell!.phone.text = callLog.phone
        }
        
        if callLog.headPhoto == nil {
            cell!.headPhoto.image = R.image.head_photo_default()!
        } else {
            cell!.headPhoto.image = UIImage(data: callLog.headPhoto!)
        }
        print("callLog.callState:\(callLog.callState)")
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
        
        if callLog.callType == CallType.Voice.rawValue {
            cell!.callType.image = R.image.voice_call()
        } else {
            cell!.callType.image = R.image.video_call()
        }
        
        cell!.area.text = callLog.area
        
        cell!.callStartTime.text = DateUtil.dateToString(callLog.callStartTime)
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let callLog = self.callLogs![indexPath.row]
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        alertController.addAction(UIAlertAction(title: "语音通话", style: .Default) { action in
            let outgoingCallViewController = R.storyboard.main.outgoingCallViewController()
            outgoingCallViewController?.contactId = callLog.identifier
            outgoingCallViewController?.toNumber = callLog.phone
            outgoingCallViewController?.contactName = callLog.name
            outgoingCallViewController?.phoneArea = callLog.area
            self.presentViewController(outgoingCallViewController!, animated: true, completion: nil)
            })
        alertController.addAction(UIAlertAction(title: "视频通话", style: .Default) { action in
            let outgoingVideoViewController = OutgoingVideoViewController()
            outgoingVideoViewController.toNumber = callLog.phone
            self.presentViewController(outgoingVideoViewController, animated: true, completion: nil)
            })
        alertController.addAction(UIAlertAction(title: "举报", style: .Destructive) { action in
            
            })
        alertController.addAction(UIAlertAction(title: "取消", style: .Cancel) { action in
            
            })
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let callLog = callLogs![indexPath.row]
            try! App.realm.write {
                App.realm.delete(callLog)
            }
            callLogs = App.realm.objects(CallLog.self).sorted("callStartTime", ascending: false)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func reloadCallLogs() {
        callLogs = App.realm.objects(CallLog.self).sorted("callStartTime", ascending: false)
        tableView.reloadData()
    }
    
    func deleteAllCallLogs() {
        try! App.realm.write {
            App.realm.delete(callLogs!)
        }
        reloadCallLogs()
    }
}
