//
//  BackupViewController.swift
//  18phone
//
//  Created by 戴全艺 on 16/9/18.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit
import Contacts

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
        
        switch (indexPath as NSIndexPath).row {
        case 0:
            cell!.detailTextLabel!.text = "\(contactCount)人"
            
            break
        case 1:
            cell!.detailTextLabel!.text = "\(contactCount)人"
            break
        case 2:
            cell!.detailTextLabel!.text = "上次同步2016/09/15"
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
        let store = CNContactStore()
        let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey as CNKeyDescriptor, CNContactThumbnailImageDataKey as CNKeyDescriptor, CNContactImageDataAvailableKey as CNKeyDescriptor]
        let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)
        try! store.enumerateContacts(with: fetchRequest) { contact, stop in
            if self.contactCount == 0 {
                var phones = ""
                for number in contact.phoneNumbers {
                    let phoneNumber = number.value.stringValue
                    let formatNumber = PhoneUtil.formatPhoneNumber(phoneNumber)
                    if contact.phoneNumbers.count == 1 {
                        phones = formatNumber
                    } else {
                        phones = phones + "," + formatNumber
                    }
                }
                if let userID = UserDefaults.standard.string(forKey: "userID") {
                    let uploadContactInfo = ["phoneID":contact.identifier, "userID":userID, "name":contact.familyName + contact.givenName,"mobile":phones, "sex":0, "age":-1, "area":""] as [String : Any]
                    APIUtil.uploadContact(uploadContactInfo)
                }
                
            }
        }
        
    }
}
