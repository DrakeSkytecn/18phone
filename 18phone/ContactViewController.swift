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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollsToTopEnable(false)
        tableView.tableFooterView?.hidden = true
        tableView.sectionIndexBackgroundColor = UIColor.clearColor()
        loadContacts()
        initGroup()
        
//        Async.background {
//            
//        }.main {
//            
//        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        print("ContactViewController viewDidDisappear")
    }
    
    func scrollsToTopEnable(enable: Bool) {
        tableView.scrollsToTop = enable
    }
    
    func loadContacts() {
        let store = CNContactStore()
        let keysToFetch = [CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName),
                           CNContactImageDataKey,
                           CNContactThumbnailImageDataKey,
                           CNContactImageDataAvailableKey,
                           CNContactPhoneNumbersKey,
                           CNContactPhoneticGivenNameKey,
                           CNContactPhoneticFamilyNameKey]
        
        let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)
        
        do {
            try store.enumerateContactsWithFetchRequest(fetchRequest) { (let contact, let stop) -> Void in
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
            let key = String(UnicodeScalar(Int(UnicodeScalar("A").value) + i))
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
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return groupTitles.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupValues[groupTitles[section]]!!.count
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return groupTitles
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.contact)
        let localContactInfo = groupValues[groupTitles[indexPath.section]]!![indexPath.row]
        cell!.name.text = localContactInfo.name
        if localContactInfo.headPhoto != nil {
            cell?.headPhoto.image = UIImage(data: localContactInfo.headPhoto!)
        } else {
            cell?.headPhoto.image = R.image.head_photo_default()
        }
        if localContactInfo.isRegister {
            cell?.registerIcon.image = R.image.is_register()
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
        label.text = groupTitles[section]
        label.font = UIFont.systemFontOfSize(14.0)
        label.textColor = UIColor.grayColor()
        view.addSubview(label)
        return view
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

