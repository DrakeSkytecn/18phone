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
    
    @IBAction func videoCall(_ sender: UIButton) {
        
    }
    
    @IBAction func voiceCall(_ sender: UIButton) {
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return phones!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.detail_phone_cell)
        let phoneNumber = phones![(indexPath as NSIndexPath).row]
        cell?.textLabel?.text = phoneNumber
        cell?.detailTextLabel?.text = "未知归属地"
        PhoneUtil.getPhoneAreaInfo(phoneNumber) { phoneAreaInfo in
            if phoneAreaInfo.errNum == 0 {
                cell?.detailTextLabel?.text = (phoneAreaInfo.retData?.province!)! + (phoneAreaInfo.retData?.city!)!
            }
        }

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        PhoneUtil.callSystemPhone(phones![(indexPath as NSIndexPath).row])
        addCallLog(phones![(indexPath as NSIndexPath).row], area: tableView.cellForRow(at: indexPath)!.detailTextLabel!.text!)
    }
    
    func addCallLog(_ number: String, area: String) {
        let callLog = CallLog()
        callLog.identifier = identifier!
        callLog.name = name!
        callLog.phone = number
        if true {
            callLog.callState = CallState.outConnected.rawValue
        } else {
            callLog.callState = CallState.outUnConnected.rawValue
        }
        callLog.callType = CallType.voice.rawValue
        callLog.callStartTime = Date()
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
