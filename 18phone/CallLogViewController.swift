//
//  CallLogViewController.swift
//  bottompopmenu
//
//  Created by 戴全艺 on 16/7/27.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftEventBus

class CallLogViewController: UITableViewController {
    
    var callLogs: Results<CallLog>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callLogs = App.realm.objects(CallLog.self).sorted(byProperty: "callStartTime", ascending: false)
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
    
    func scrollsToTopEnable(_ enable: Bool) {
        tableView.scrollsToTop = enable
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return callLogs!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.log_a)
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
            cell!.headPhoto.image = UIImage(data: callLog.headPhoto! as Data)
        }
        print("callLog.callState:\(callLog.callState)")
        switch callLog.callState {
        case CallState.inUnConnected.rawValue:
            cell!.callState.image = R.image.call_in_unconnected()
            break
        case CallState.inConnected.rawValue:
            cell!.callState.image = R.image.call_in_connected()
            break
        case CallState.outUnConnected.rawValue:
            cell!.callState.image = R.image.call_out_unconnected()
            break
        case CallState.outConnected.rawValue:
            cell!.callState.image = R.image.call_out_connected()
            break
        default:
            break
        }
        
        if callLog.callType == CallType.voice.rawValue {
            cell!.callType.image = R.image.voice_call()
        } else {
            cell!.callType.image = R.image.video_call()
        }
        
        cell!.area.text = callLog.area
        
        cell!.callStartTime.text = DateUtil.dateToString(callLog.callStartTime)
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let callLog = self.callLogs![indexPath.row]
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "语音通话", style: .default) { action in
            let outgoingCallViewController = R.storyboard.main.outgoingCallViewController()
            outgoingCallViewController?.contactId = callLog.contactId
            outgoingCallViewController?.toNumber = callLog.phone
            outgoingCallViewController?.contactName = callLog.name
            outgoingCallViewController?.phoneArea = callLog.area
            self.present(outgoingCallViewController!, animated: true, completion: nil)
            })
        alertController.addAction(UIAlertAction(title: "视频通话", style: .default) { action in
            let outgoingVideoViewController = R.storyboard.main.outgoingVideoViewController()
            outgoingVideoViewController!.toNumber = callLog.phone
            self.present(outgoingVideoViewController!, animated: true, completion: nil)
            })
        alertController.addAction(UIAlertAction(title: "举报", style: .destructive) { action in
            
            })
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel) { action in
            
            })
        present(alertController, animated: true, completion: nil)
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let callLog = callLogs![indexPath.row]
            try! App.realm.write {
                App.realm.delete(callLog)
            }
            callLogs = App.realm.objects(CallLog.self).sorted(byProperty: "callStartTime", ascending: false)
            tableView.deleteRows(at: [indexPath], with: .fade)
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
        callLogs = App.realm.objects(CallLog.self).sorted(byProperty: "callStartTime", ascending: false)
        tableView.reloadData()
    }
    
    func deleteAllCallLogs() {
        try! App.realm.write {
            App.realm.delete(callLogs!)
        }
        reloadCallLogs()
    }
}
