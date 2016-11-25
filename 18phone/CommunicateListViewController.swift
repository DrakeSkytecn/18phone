//
//  CommunicateListViewController.swift
//  18phone
//
//  Created by 戴全艺 on 2016/10/19.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit

class CommunicateListViewController: UITableViewController {

    var year: Int?
    var month: Int?
    var callLogInfos: [CallLogInfo]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        APIUtil.getCallLogByMonth(UserDefaults.standard.string(forKey: "userID")!, year: year!, month: month!, callBack: { callLogInfos in
            if callLogInfos.codeStatus == 1 {
                self.callLogInfos = callLogInfos.callLogInfos
                self.tableView.reloadData()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if callLogInfos != nil {
            return callLogInfos!.count
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let callLogInfo = callLogInfos![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.bill_call_log)!
        cell.phone.text = callLogInfo.BMobile
        cell.name.text = callLogInfo.Name
        switch callLogInfo.IncomingType! {
        case CallState.inUnConnected.rawValue:
            cell.callState.image = R.image.call_in_unconnected()
            break
        case CallState.inConnected.rawValue:
            cell.callState.image = R.image.call_in_connected()
            break
        case CallState.outUnConnected.rawValue:
            cell.callState.image = R.image.call_out_unconnected()
            break
        case CallState.outConnected.rawValue:
            cell.callState.image = R.image.call_out_connected()
            break
        default:
            break
        }
        if callLogInfo.CallType == CallType.voice.rawValue {
            cell.callType.image = R.image.voice_call()
        } else if callLogInfo.CallType == CallType.video.rawValue {
            cell.callType.image = R.image.video_call()
        }
        cell.callStartTime.text = callLogInfo.CallTime

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
