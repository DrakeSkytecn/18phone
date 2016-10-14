//
//  CallLogMenuViewController.swift
//  18phone
//
//  Created by 戴全艺 on 16/9/22.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftEventBus

class CallLogMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var contactId: String?
    
    var callLogs: Results<CallLog>?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        callLogs = App.realm.objects(CallLog.self).filter("identifier == '\(contactId!)'").sorted(byProperty: "callStartTime", ascending: false)
        SwiftEventBus.onMainThread(self, name: "reloadCallLogs") { result in
            self.reloadCallLogs()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadCallLogs() {
        callLogs = App.realm.objects(CallLog.self).filter("identifier == '\(contactId!)'").sorted(byProperty: "callStartTime", ascending: false)
        tableView.reloadData()
    }
    
    @IBAction func clearAllCallLog(_ sender: UIButton) {
        if callLogs!.count != 0 {
            let alertController = UIAlertController(title: "清空通话记录", message: "此操作不可撤回，确认清除所有的通话记录吗？", preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: "确认", style: .destructive) { action in
                try! App.realm.write {
                    App.realm.delete(self.callLogs!)
                }
                self.reloadCallLogs()
                SwiftEventBus.post("reloadCallLogs")
                })
            alertController.addAction(UIAlertAction(title: "取消", style: .cancel) { action in
                
                })
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return callLogs!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let callLog = callLogs![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.detail_log_cell)
        if callLog.callType == CallType.voice.rawValue {
            cell!.callType.image = R.image.voice_call()
        } else {
            cell!.callType.image = R.image.video_call()
        }
        cell?.callStartTime.text = DateUtil.dateToString(callLog.callStartTime)
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
        //cell?.callDuration = callLog.callDuration
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
