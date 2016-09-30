//
//  DetailMenuViewController.swift
//  18phone
//
//  Created by 戴全艺 on 16/9/21.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit

class DetailMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var identifier: String?
    var name: String?
    var phones: [String]?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func videoCall(sender: UIButton) {
        
    }
    
    @IBAction func voiceCall(sender: UIButton) {
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return phones!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.detail_phone_cell)
        let phoneNumber = phones![indexPath.row]
        cell?.textLabel?.text = phoneNumber
        cell?.detailTextLabel?.text = "未知归属地"
        PhoneUtil.getPhoneAreaInfo(phoneNumber) { phoneAreaInfo in
            if phoneAreaInfo.errNum == 0 {
                cell?.detailTextLabel?.text = (phoneAreaInfo.retData?.province!)! + (phoneAreaInfo.retData?.city!)!
            }
        }

        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        PhoneUtil.callSystemPhone(phones![indexPath.row])
        addCallLog(phones![indexPath.row], area: tableView.cellForRowAtIndexPath(indexPath)!.detailTextLabel!.text!)
    }
    
    func addCallLog(number: String, area: String) {
        let callLog = CallLog()
        callLog.identifier = identifier!
        callLog.name = name!
        callLog.phone = number
        if true {
            callLog.callState = CallState.OutConnected.rawValue
        } else {
            callLog.callState = CallState.OutUnConnected.rawValue
        }
        callLog.callType = CallType.Voice.rawValue
        callLog.callStartTime = NSDate()
        callLog.area = area
        try! App.realm.write {
            App.realm.add(callLog)
        }
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
