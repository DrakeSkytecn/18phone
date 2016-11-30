//
//  BackupViewController.swift
//  18phone
//
//  Created by 戴全艺 on 16/9/18.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit
import Contacts
import SwiftHTTP
import Async

class BackupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var contactCount = 0
    
    let titles = ["本地通讯录", "云端通讯录", "同步通讯录", "恢复通讯录", "自动同步"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        let store = CNContactStore()
        let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName)]
        let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)
        try! store.enumerateContacts(with: fetchRequest) { contact, stop in
            self.contactCount = self.contactCount + 1
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.backup_cell_a)
        cell!.textLabel!.text = titles[indexPath.row]
        cell?.selectionStyle = .none
        
        switch indexPath.row {
        case 0:
            cell!.detailTextLabel!.text = "\(contactCount)人"
            
            break
        case 1:
            if let upsucceedCount = UserDefaults.standard.string(forKey: "upsucceedCount") {
                cell!.detailTextLabel!.text = "\(upsucceedCount)人"
            }
            break
        case 2:
            if let backupEndTime = UserDefaults.standard.string(forKey: "backupEndTime") {
                cell!.detailTextLabel!.text = "上次同步\(backupEndTime)"
            }
            break
        case 3:
            cell?.selectionStyle = .default
            break
        case 4:
            let autoSwitch = UISwitch(frame: CGRect(x: 0, y: 0, width: 51, height: 31))
            autoSwitch.isOn = UserDefaults.standard.bool(forKey: "auto_backup")
            cell?.accessoryView = autoSwitch
            autoSwitch.addTarget(self, action: #selector(switchAction(_:)), for: .valueChanged)
            break
        default:
            break
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func switchAction(_ sender: UISwitch) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(sender.isOn, forKey: "auto_backup")
        userDefaults.synchronize()
    }
    
    @IBAction func backupContacts(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "好的", style: .default, handler: nil)
        alertController.addAction(okAction)
        if let userID = UserDefaults.standard.string(forKey: "userID") {
            let store = CNContactStore()
            let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey as CNKeyDescriptor, CNContactThumbnailImageDataKey as CNKeyDescriptor, CNContactImageDataAvailableKey as CNKeyDescriptor]
            let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)
            var contactBackups = [[String : Any]]()
            try! store.enumerateContacts(with: fetchRequest) { contact, stop in
                var phones = ""
                for number in contact.phoneNumbers {
                    let phoneNumber = number.value.stringValue
                    let formatNumber = PhoneUtil.formatPhoneNumber(phoneNumber)
                    if phones.isEmpty {
                        phones = formatNumber
                    }
                    phones = phones + "," + formatNumber
                }
                let appContactInfo = App.realm.objects(AppContactInfo.self).filter("identifier == '\(contact.identifier)'").first!
                var contactBackup: [String : Any] = ["phoneID":contact.identifier, "userID":userID, "name":contact.familyName + contact.givenName,"mobile":phones, "sex":appContactInfo.sex, "age":appContactInfo.age, "area":appContactInfo.area]
                if contact.imageDataAvailable {
                    contactBackup["imageBase64String"] = contact.thumbnailImageData!.base64EncodedString()
                } else {
                    contactBackup["imageBase64String"] = ""
                }
                contactBackups.append(contactBackup)
            }
            let contactBackupsJson = try! JSONSerialization.data(withJSONObject: contactBackups, options: JSONSerialization.WritingOptions.prettyPrinted)
            let jsonString = NSString(data: contactBackupsJson, encoding: String.Encoding.utf8.rawValue)
            APIUtil.uploadContact(jsonString as! String, callBack: { backupContactInfo in
                if backupContactInfo.codeStatus == 1 {
                    alertController.message = "备份成功"
                    self.present(alertController, animated: true, completion: nil)
                    self.tableView.cellForRow(at: IndexPath(row: 1, section: 0))?.detailTextLabel?.text = "\(backupContactInfo.upsucceedCount!)人"
                    self.tableView.cellForRow(at: IndexPath(row: 2, section: 0))?.detailTextLabel?.text = "上次同步\(backupContactInfo.endTime!)"
                    let userDefaults = UserDefaults.standard
                    userDefaults.set(backupContactInfo.endTime, forKey: "backupEndTime")
                    userDefaults.set(backupContactInfo.upsucceedCount, forKey: "upsucceedCount")
                    userDefaults.synchronize()
                }
            })
        }
    }
}
