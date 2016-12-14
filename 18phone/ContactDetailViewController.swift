//
//  ContactDetailViewController.swift
//  18phone
//
//  Created by 戴全艺 on 16/9/20.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import RealmSwift

class ContactDetailViewController: UIViewController {
    
    @IBOutlet weak var detailConHeight: NSLayoutConstraint!
    
    var contactId: String?
    
    var phones = [String]()
    
    var phoneAreas = [String]()
    
    var appContactInfo: AppContactInfo?
    
    var contact: CNContact?
    
    @IBOutlet weak var headPhoto: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var sexImage: UIImageView!
    
    @IBOutlet weak var signLabel: UILabel!
    
    @IBOutlet weak var areaLabel: UILabel!
    
    @IBOutlet weak var ageLabel: UILabel!
    
    var detailMenuViewController = R.storyboard.main.detailMenuViewController()!
    
    var callLogMenuViewController = R.storyboard.main.callLogMenuViewController()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initContactInfo()
        initPageMenu()
        SwiftEventBus.onMainThread(self, name: "reloadAppContactInfo") { result in
            self.reloadAppContactInfo()
        }
        SwiftEventBus.onMainThread(self, name: "reloadLocalContactInfo") { result in
            let contact = result.object as! CNContact
            self.reloadLocalContactInfo(contact)
        }
        // Do any additional setup after loading the view.
    }
    
    func initContactInfo() {
        let store = CNContactStore()
        let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                           CNContactImageDataKey,
                           CNContactThumbnailImageDataKey,
                           CNContactImageDataAvailableKey,
                           CNContactPhoneNumbersKey,
                           CNContactPhoneticGivenNameKey,
                           CNContactPhoneticFamilyNameKey, CNContactViewController.descriptorForRequiredKeys()] as [Any]
        
        contact = try! store.unifiedContact(withIdentifier: contactId!, keysToFetch: keysToFetch as! [CNKeyDescriptor])
        appContactInfo = App.realm.objects(AppContactInfo.self).filter("identifier == '\(contactId!)'").first
        if contact!.imageDataAvailable {
            headPhoto.image = UIImage(data: contact!.thumbnailImageData!)
            detailMenuViewController.headPhoto = contact?.thumbnailImageData
        } else {
            headPhoto.image = R.image.head_photo_default()
        }
        let fullName = contact!.familyName + contact!.givenName
        nameLabel.text = fullName
        
        switch appContactInfo!.sex {
        case Sex.male.rawValue:
            sexImage.image = R.image.male()
            break
        case Sex.female.rawValue:
            sexImage.image = R.image.female()
            break
        default:
            break
        }
        
        signLabel.text = appContactInfo!.signature
        areaLabel.text = appContactInfo!.area
        if appContactInfo!.age != -1 {
            ageLabel.text = "\(appContactInfo!.age)岁"
        }
        phones.removeAll()
        phoneAreas.removeAll()
        for number in contact!.phoneNumbers {
            let phoneNumber = number.value.stringValue
            let formatNumber = PhoneUtil.formatPhoneNumber(phoneNumber)
            phones.append(phoneNumber)
            let area = App.realm.objects(Area.self).filter("key == '\(formatNumber)'").first!
            phoneAreas.append(area.name)
        }
        
        detailMenuViewController.contactId = contactId
        detailMenuViewController.name = fullName
        detailMenuViewController.phones = phones
        detailMenuViewController.phoneAreas = phoneAreas
        detailMenuViewController.appContactInfo = appContactInfo
        callLogMenuViewController.contactId = contactId
    }
    
    func initPageMenu() {
        let controllerArray : [UIViewController] = [detailMenuViewController, callLogMenuViewController]
        let parameters: [CAPSPageMenuOption] = [
            .scrollMenuBackgroundColor(UIColor.white),
            .viewBackgroundColor(UIColor.white),
            .selectionIndicatorColor(UIColor(red: 38.0/255.0, green: 173.0/255.0, blue: 86.0/255.0, alpha: 1.0)),
            .selectedMenuItemLabelColor(UIColor(red: 38.0/255.0, green: 173.0/255.0, blue:  86.0/255.0, alpha: 1.0)),
            .unselectedMenuItemLabelColor(UIColor.black),
            .bottomMenuHairlineColor(UIColor(red: 70.0/255.0, green: 70.0/255.0, blue: 80.0/255.0, alpha: 1.0)),
            .centerMenuItems(true),
            .menuItemWidth(Screen.width / 2),
            .menuMargin(0.0)
        ]
        let pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0, y: detailConHeight.constant, width: Screen.width, height: view.frame.height - detailConHeight.constant), pageMenuOptions: parameters)
        addChildViewController(pageMenu)
        view.addSubview(pageMenu.view)
    }
    
    func reloadAppContactInfo() {
        if appContactInfo!.sex == Sex.male.rawValue {
            sexImage.image = R.image.male()
        } else if appContactInfo!.sex == Sex.female.rawValue {
            sexImage.image = R.image.female()
        }
        if appContactInfo!.age != -1 {
            ageLabel.text = "\(appContactInfo!.age)岁"
        }
        areaLabel.text = appContactInfo!.area
    }
    
    func reloadLocalContactInfo(_ contact: CNContact) {
        nameLabel.text = contact.familyName + contact.givenName
        if contact.imageDataAvailable {
            headPhoto.image = UIImage(data: contact.thumbnailImageData!)
        } else {
            headPhoto.image = R.image.head_photo_default()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func moreFeature(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "编辑联系人", style: .default) { action in
            self.performSegue(withIdentifier: R.segue.contactDetailViewController.editContactViewController, sender: ["appContactInfo":self.appContactInfo!, "contact":self.contact!])
        })
        //        alertController.addAction(UIAlertAction(title: "添加黑名单", style: .default) { action in
        //
        //            })
        if appContactInfo!.accountId.isEmpty {
            alertController.addAction(UIAlertAction(title: "分享", style: .default) { action in
                let shareParames = NSMutableDictionary()
                let userID = UserDefaults.standard.string(forKey: "userID")!
                let shareURL = "http://192.168.10.249/Register/registerPage?randomID=\(userID)"
                shareParames.ssdkSetupShareParams(byText: "注册18phone，免费通话18天\(shareURL)",
                                                  images : R.image.shareImg()!,
                                                  url : URL(string: shareURL),
                                                  title : "18phone",
                                                  type : .auto)
                shareParames.ssdkSetupSMSParams(byText: "注册18phone，免费通话18天\(shareURL)", title: "18phone", images: nil, attachments: nil, recipients: self.phones, type: .text)
                ShareSDK.showShareActionSheet(self.view, items: nil, shareParams: shareParames) { state, platformType, userdata, contentEnity, error, end in
                    switch state {
                        
                    case .success:
                        print("分享成功")
                        break
                    case .fail:
                        print("分享失败,错误描述:\(error)")
                        break
                    case .cancel:
                        print("分享取消")
                        break
                        
                    default:
                        break
                    }
                }
            })
        }
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel) { action in
            
        })
        present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.segue.contactDetailViewController.editContactViewController.identifier {
            let editContactViewController = segue.destination as! EditContactViewController
            let info = sender as! [String:Any]
            editContactViewController.appContactInfo = info["appContactInfo"] as? AppContactInfo
            editContactViewController.contact = info["contact"] as? CNContact
        }
    }
    
    deinit {
        SwiftEventBus.unregister(self)
    }
}
