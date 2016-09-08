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

    var contacts = [CNContact]()
    var groupKey = [String]()
    var groupsValue = [String: Array<LocalContactInfo>?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView?.hidden = true
        tableView.sectionIndexBackgroundColor = UIColor.clearColor()
        loadContacts()
        for i in 0...26 {
            let key = String(UnicodeScalar(Int(UnicodeScalar("A").value) + i))
            if i != 26 {
                if groupsValue[key] != nil {
                    groupKey.append(key)
                }
            }else {
                if groupsValue["#"] != nil {
                    groupKey.append("#")
                }
            }
        }
        print(groupKey)
        if let localContactInfos = groupsValue["Y"] {
            for localContactInfo in localContactInfos! {
                print("localContactInfo.name:" + localContactInfo.name!)
            }
        }
//        print("groups.count:\(groups.count)")
//        print("groups:\(groupsValue)")
//        Async.background {
//            
//        }.main {
//            
//        }
    }
    
    func loadContacts() {
        let store = CNContactStore()
        CNLabelPhoneNumberMobile
        let keysToFetch = [CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName),
                           CNContactImageDataKey,
                           CNContactThumbnailImageDataKey,
                           CNContactImageDataAvailableKey,
                           CNContactPhoneNumbersKey,
                           CNContactPhoneticGivenNameKey,
                           CNContactPhoneticFamilyNameKey]
        
        let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)
        
        do {
            try store.enumerateContactsWithFetchRequest(fetchRequest, usingBlock: { (let contact, let stop) -> Void in
                var localContactInfo = LocalContactInfo()
                localContactInfo.identifier = contact.identifier
                localContactInfo.headPhoto = contact.thumbnailImageData
                localContactInfo.name = contact.familyName + contact.givenName
                var initial = ""
                if !(localContactInfo.name?.isEmpty)! {
                    let str = StringUtil.HanToPin(localContactInfo.name!)
                    initial = str!.substringWithRange(NSRange(location: 0,length: 1)).uppercaseString
                    for scalar in initial.unicodeScalars {
                        let value = Int(scalar.value)
                        if value < 65 || value > 90 {
                            initial = "#"
                        }
                    }
                }
                for number in contact.phoneNumbers {
                    let phone = Phone()
                    phone.number = (number.value as! CNPhoneNumber).stringValue
                    localContactInfo.phones?.append(phone)
                }
                
                if var localContactInfos = self.groupsValue[initial] {
                    localContactInfos?.append(localContactInfo)
                    self.groupsValue[initial] = localContactInfos
                } else {
                    var localContactInfos = [LocalContactInfo]()
                    localContactInfos.append(localContactInfo)
                    self.groupsValue[initial] = localContactInfos
                }
                if App.realm.objects(AppContactInfo.self).filter("identifier == '\(contact.identifier)'").first == nil {
                    let appContactInfo = AppContactInfo()
                    appContactInfo.identifier = contact.identifier
                    try! App.realm.write {
                        App.realm.add(appContactInfo)
                    }
                }
            })
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return groupKey.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("groupKey:\(groupKey[section])")
        return groupsValue[groupKey[section]]!!.count
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return groupKey
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.contact)
        let localContactInfo = groupsValue[groupKey[indexPath.section]]!![indexPath.row]
        cell?.textLabel?.text = localContactInfo.name
        if localContactInfo.headPhoto == nil {
            cell?.imageView?.image = R.image.head_photo_default()
        } else {
            cell?.imageView?.image = UIImage(data: localContactInfo.headPhoto!)
        }
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRectMake(0.0, 0.0, Screen.width, 20.0))
        let label = UILabel(frame: CGRectMake(8.0, 0.0, 15.0, 20.0))
        label.text = groupKey[section]
        label.font = UIFont.systemFontOfSize(14.0)
        label.textColor = UIColor.grayColor()
        view.addSubview(label)
        return view
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

