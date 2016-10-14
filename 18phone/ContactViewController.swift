//
//  ViewController.swift
//  18phone
//
//  Created by 戴全艺 on 16/8/1.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit
import Contacts

class ContactViewController: UITableViewController {

    var groupTitles = [String]()
    var commonGroups = [String: Array<LocalContactInfo>?]()
    var registerGroups = [String: Array<LocalContactInfo>?]()
    var groupValues = [String: Array<LocalContactInfo>?]()
    var contactId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollsToTopEnable(false)
        tableView.tableFooterView?.isHidden = true
        tableView.sectionIndexBackgroundColor = UIColor.clear
        loadContacts()
        initGroup()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("ContactViewController viewDidDisappear")
    }
    
    func scrollsToTopEnable(_ enable: Bool) {
        tableView.scrollsToTop = enable
    }
    
    func loadContacts() {
        let store = CNContactStore()
        let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                           CNContactImageDataKey as CNKeyDescriptor,
                           CNContactThumbnailImageDataKey as CNKeyDescriptor,
                           CNContactImageDataAvailableKey as CNKeyDescriptor,
                           CNContactPhoneNumbersKey as CNKeyDescriptor,
                           CNContactPhoneticGivenNameKey as CNKeyDescriptor,
                           CNContactPhoneticFamilyNameKey as CNKeyDescriptor]
        
        let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)
        
        do {
            try store.enumerateContacts(with: fetchRequest) { contact, stop in
                var localContactInfo = LocalContactInfo()
                localContactInfo.identifier = contact.identifier
                var appContactInfo = App.realm.objects(AppContactInfo.self).filter("identifier == '\(contact.identifier)'").first
                if  appContactInfo == nil {
                    appContactInfo = AppContactInfo()
                    appContactInfo!.identifier = contact.identifier
                    try! App.realm.write {
                        App.realm.add(appContactInfo!)
                    }
                } else {
                    //check is register
                    
                }
                localContactInfo.headPhoto = contact.thumbnailImageData
                localContactInfo.name = contact.familyName + contact.givenName
                var initial = ""
                if !(localContactInfo.name?.isEmpty)! {
                    let str = StringUtil.HanToPin(localContactInfo.name!)
                    initial = str!.substring(with: NSRange(location: 0,length: 1)).uppercased()
                    for scalar in initial.unicodeScalars {
                        let value = Int(scalar.value)
                        if value < 65 || value > 90 {
                            initial = "#"
                        }
                    }
                }
                for number in contact.phoneNumbers {
                    let phone = Phone()
                    phone.number = (number.value ).stringValue
                    localContactInfo.phones?.append(phone)
                }
                if var localContactInfos = self.groupValues[initial] {
                    localContactInfos?.append(localContactInfo)
                    self.groupValues[initial] = localContactInfos
                } else {
                    var localContactInfos = [LocalContactInfo]()
                    localContactInfos.append(localContactInfo)
                    self.groupValues[initial] = localContactInfos
                }
            }
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func initGroup() {
        for i in 0...26 {
            let key = String(describing: UnicodeScalar(Int(UnicodeScalar("A").value) + i)!)
            if i != 26 {
                if groupValues[key] != nil {
                    groupTitles.append(key)
                }
            }else {
                if groupValues["#"] != nil {
                    groupTitles.append("#")
                }
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return groupTitles.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupValues[groupTitles[section]]!!.count
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return groupTitles
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.contact)
        let localContactInfo = groupValues[groupTitles[(indexPath as NSIndexPath).section]]!![(indexPath as NSIndexPath).row]
        cell!.name.text = localContactInfo.name
        if localContactInfo.headPhoto != nil {
            cell?.headPhoto.image = UIImage(data: localContactInfo.headPhoto! as Data)
        } else {
            cell?.headPhoto.image = R.image.head_photo_default()
        }
        if localContactInfo.isRegister {
            cell?.registerIcon.image = R.image.is_register()
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: Screen.width, height: 20.0))
        let label = UILabel(frame: CGRect(x: 8.0, y: 0.0, width: 15.0, height: 20.0))
        label.text = groupTitles[section]
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = UIColor.gray
        view.addSubview(label)
        return view
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let localContactInfo = groupValues[groupTitles[(indexPath as NSIndexPath).section]]!![(indexPath as NSIndexPath).row]
        contactId = localContactInfo.identifier!
        performSegue(withIdentifier: R.segue.contactViewController.contactDetailViewController.identifier, sender: contactId)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.segue.contactViewController.contactDetailViewController.identifier {
            let contactDetailViewController = segue.destination as? ContactDetailViewController
            contactDetailViewController?.contactId = sender as? String
        }
    }
}

