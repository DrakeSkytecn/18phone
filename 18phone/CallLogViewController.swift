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
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return callLogs!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.log_a)
        let callLog = callLogs![indexPath.row]
        cell!.headPhoto.piQ_imageFromUrl(callLog.headPhoto, placeholderImage: R.image.head_photo_default()!)
        print("callLog.callState:\(callLog.callState)")
        switch callLog.callState {
            case CallState.InUnConnected.rawValue:
                cell!.callState.image = R.image.call_in()
                break
            case CallState.InConnected.rawValue:
                cell!.callState.image = R.image.call_in()
                break
            case CallState.OutUnConnected.rawValue:
                cell!.callState.image = R.image.call_out()
                break
            case CallState.OutConnected.rawValue:
                cell!.callState.image = R.image.call_out()
                break
            default:
                break
        }
        
        if callLog.callType == 0 {
            cell!.callType.image = R.image.voice_call()
        } else {
            cell!.callType.image = R.image.video_call()
        }
        
        if callLog.name.isEmpty {
            cell!.name.text = callLog.phone
        } else {
            cell!.name.text = callLog.name
            cell!.phone.text = callLog.phone
        }
        
        cell!.area.text = callLog.area
        
        cell!.callStartTime.text = DateUtil.dateToString(callLog.callStartTime)
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let callLog = callLogs![indexPath.row]
        let outgoingCallViewController = R.storyboard.main.outgoingCallViewController()
        outgoingCallViewController?.toNumber = callLog.phone
        outgoingCallViewController?.contactName = "James"
        outgoingCallViewController?.phoneArea = callLog.area
        presentViewController(outgoingCallViewController!, animated: true, completion: nil)
//                let outgoingVideoViewController = OutgoingVideoViewController()
//                outgoingVideoViewController.toNumber = callLog.phone
//                presentViewController(outgoingVideoViewController, animated: true, completion: nil)
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
