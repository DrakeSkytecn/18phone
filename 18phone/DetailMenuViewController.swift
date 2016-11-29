//
//  DetailMenuViewController.swift
//  18phone
//
//  Created by 戴全艺 on 16/9/21.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftEventBus

class DetailMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var appContactInfo: AppContactInfo?
    var callId: String?
    var contactId: String?
    var name: String?
    var phones: [String]?
    var phoneAreas: [String]?
    var pending: UIAlertController?
    var callLog = CallLog()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        SwiftEventBus.onMainThread(self, name: "getBackCallInfo") { result in
            self.pending?.dismiss(animated: false, completion: nil)
            if self.callId != nil {
                PhoneUtil.getBackCallInfo(self.callId!, callBack: { backCallInfo in
                    if backCallInfo.status == "0" {
                        
                    }
                })
                self.callId = nil
                self.addCallLog()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func videoCall(_ sender: UIButton) {
        if  appContactInfo != nil && !appContactInfo!.accountId.isEmpty {
            let outgoingVideoViewController = R.storyboard.main.outgoingVideoViewController()
            callLog.accountId = appContactInfo!.accountId
            callLog.contactId = appContactInfo!.identifier
            callLog.phone = phones!.first!
            callLog.name = name!
            callLog.area = phoneAreas!.first!
            callLog.callType = CallType.video.rawValue
            outgoingVideoViewController?.callLog = callLog
            present(outgoingVideoViewController!, animated: true, completion: nil)
        }
    }
    
    @IBAction func voiceCall(_ sender: UIButton) {
        if  appContactInfo != nil && !appContactInfo!.accountId.isEmpty {
            let outgoingCallViewController = R.storyboard.main.outgoingCallViewController()
            callLog.accountId = appContactInfo!.accountId
            callLog.contactId = appContactInfo!.identifier
            callLog.phone = phones!.first!
            callLog.name = name!
            callLog.area = phoneAreas!.first!
            callLog.callType = CallType.voice.rawValue
            outgoingCallViewController?.callLog = callLog
            present(outgoingCallViewController!, animated: true, completion: nil)
        } else {
            if let saveUsername = UserDefaults.standard.string(forKey: "username") {
                pending = UIAlertController(title: "回拨电话", message: "正在拨号中，您将收到一通回拨电话，接听等待即可通话", preferredStyle: .alert)
                let indicator = UIActivityIndicatorView(frame: pending!.view.bounds)
                indicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                pending?.view.addSubview(indicator)
                pending?.addAction(UIAlertAction(title: "挂断", style: .cancel) { action in
                    if self.callId != nil {
                        PhoneUtil.hangupBackCall(self.callId!, callBack: { dialBackCallInfo in
                            if dialBackCallInfo.status == "0" {
                                self.pending?.dismiss(animated: true, completion: nil)
                            }
                        })
                    }
                })
                present(pending!, animated: true, completion: nil)
                if phones!.first != nil {
                    PhoneUtil.dialBackCall(saveUsername, toNumber: phones!.first!, callBack: { dialBackCallInfo in
                        if dialBackCallInfo.status == "0" {
                            self.callId = dialBackCallInfo.callId
                        }
                    })
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return phones!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.detail_phone_cell)
        let phoneNumber = phones![indexPath.row]
        let phoneArea = phoneAreas![indexPath.row]
        cell?.textLabel?.text = phoneNumber // 号码
        if phoneArea.isEmpty || phoneArea == "未知" {
            cell?.detailTextLabel?.text = "未知" // 归属地
            PhoneUtil.getPhoneAreaInfo(phoneNumber) { phoneAreaInfo in
                let area = App.realm.objects(Area.self).filter("key == '\(phoneNumber)'").first!
                if phoneAreaInfo.errNum == 0 {
                    let province = phoneAreaInfo.retData!.province!
                    let city = phoneAreaInfo.retData!.city!
                    let fullArea = province + city
                    switch province {
                    case "北京", "上海", "天津", "重庆":
                        cell?.detailTextLabel?.text = province
                        self.phoneAreas![indexPath.row] = province
                        break
                    default:
                        cell?.detailTextLabel?.text = fullArea
                        self.phoneAreas![indexPath.row] = fullArea
                        break
                    }
                    try! App.realm.write {
                        area.name = fullArea
                    }
                } else {
                    cell?.detailTextLabel?.text = "未知"
                    try! App.realm.write {
                        area.name = "未知"
                    }
                }
            }
        } else {
            cell?.detailTextLabel?.text = phoneArea
        }

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func addCallLog() {
        if appContactInfo != nil {
            callLog.contactId = appContactInfo!.identifier
        }
        callLog.name = name!
        callLog.phone = phones!.first!
        if true {
            callLog.callState = CallState.outConnected.rawValue
        } else {
            callLog.callState = CallState.outUnConnected.rawValue
        }
        callLog.callType = CallType.voice.rawValue
        callLog.area = phoneAreas!.first!
        try! App.realm.write {
            App.realm.add(callLog)
        }
        let callInfo = ["AuserID":UserDefaults.standard.string(forKey: "userID")!, "BUCID":callLog.accountId, "CallType":callLog.callType, "IncomingType":callLog.callState, "CallTime":callLog.callStartTime.description, "TalkTimeLength":"1000", "EndTime":callLog.callEndTime.description, "Area":callLog.area, "Name":callLog.name, "Mobile":callLog.phone] as [String : Any]
        APIUtil.saveCallLog(callInfo)
    }
    
    deinit {
        SwiftEventBus.unregister(self)
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
