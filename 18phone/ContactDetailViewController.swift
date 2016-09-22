//
//  ContactDetailViewController.swift
//  18phone
//
//  Created by 戴全艺 on 16/9/20.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit
import Contacts
import PageMenu

class ContactDetailViewController: UIViewController {

    var contactId: String?
    
    var phones = [String]()
    
    @IBOutlet weak var headPhoto: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var sexImage: UIImageView!
    
    @IBOutlet weak var signLabel: UILabel!
    
    @IBOutlet weak var areaLabel: UILabel!
    
    @IBOutlet weak var ageLabel: UILabel!
    
    @IBOutlet weak var detailCon: UIView!
    
    @IBOutlet weak var pageMenuCon: UIView!
    
    var pageMenu : CAPSPageMenu?
    
    var detailMenuViewController = R.storyboard.main.detailMenuViewController()
    
    var callLogMenuViewController = R.storyboard.main.callLogMenuViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(contactId)
        initContactInfo()
        initPageMenu()
        // Do any additional setup after loading the view.
    }
    
    func initContactInfo() {
        let store = CNContactStore()
        let keysToFetch = [CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName),
                           CNContactImageDataKey,
                           CNContactThumbnailImageDataKey,
                           CNContactImageDataAvailableKey,
                           CNContactPhoneNumbersKey,
                           CNContactPhoneticGivenNameKey,
                           CNContactPhoneticFamilyNameKey]
        
        let contact = try! store.unifiedContactWithIdentifier(contactId!, keysToFetch: keysToFetch)
        let appContactInfo = App.realm.objects(AppContactInfo.self).filter("identifier == '\(contactId!)'").first
        if contact.imageDataAvailable {
            headPhoto.image = UIImage(data: contact.thumbnailImageData!)
        } else {
            headPhoto.image = R.image.head_photo_default()
        }
        
        nameLabel.text = contact.familyName + contact.givenName
        
        switch appContactInfo!.sex {
        case Sex.Male.rawValue:
            sexImage.image = R.image.male()
            break
        case Sex.Female.rawValue:
            sexImage.image = R.image.male()
            break
        default:
            break
        }
        
        signLabel.text = appContactInfo?.signature
        areaLabel.text = appContactInfo?.area
        if appContactInfo?.age != -1 {
            ageLabel.text = "\(appContactInfo?.age)"
        }
        phones.removeAll()
        for number in contact.phoneNumbers {
            let phoneNumber = (number.value as! CNPhoneNumber).stringValue
            phones.append(phoneNumber)
        }
        detailMenuViewController?.phones = phones
        callLogMenuViewController?.contactId = contactId
    }
    
    func initPageMenu() {
        let controllerArray : [UIViewController] = [detailMenuViewController!, callLogMenuViewController!]
        let parameters: [CAPSPageMenuOption] = [
            .ScrollMenuBackgroundColor(UIColor.whiteColor()),
            .ViewBackgroundColor(UIColor.whiteColor()),
            .SelectionIndicatorColor(UIColor(red: 38.0/255.0, green: 173.0/255.0, blue: 86.0/255.0, alpha: 1.0)),
            .SelectedMenuItemLabelColor(UIColor(red: 38.0/255.0, green: 173.0/255.0, blue: 86.0/255.0, alpha: 1.0)),
            .UnselectedMenuItemLabelColor(UIColor.blackColor()),
            .BottomMenuHairlineColor(UIColor(red: 70.0/255.0, green: 70.0/255.0, blue: 80.0/255.0, alpha: 1.0)),
            .CenterMenuItems(true)
        ]
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0, detailCon.frame.height, Screen.width, view.frame.height - detailCon.frame.height), pageMenuOptions: parameters)
        addChildViewController(pageMenu!)
        view.addSubview(pageMenu!.view)
        pageMenu!.didMoveToParentViewController(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func moreFeature(sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        alertController.addAction(UIAlertAction(title: "编辑联系人", style: .Default) { action in
            
            })
        alertController.addAction(UIAlertAction(title: "添加黑名单", style: .Default) { action in
            
            })
        alertController.addAction(UIAlertAction(title: "分享", style: .Default) { action in
            
            })
        alertController.addAction(UIAlertAction(title: "取消", style: .Cancel) { action in
            
            })
        presentViewController(alertController, animated: true, completion: nil)
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
