//
//  ContactDetailViewController.swift
//  18phone
//
//  Created by 戴全艺 on 16/9/20.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit
import Contacts

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
    
    var detailMenuViewController = R.storyboard.main.detailMenuViewController()!
    
    var callLogMenuViewController = R.storyboard.main.callLogMenuViewController()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(contactId)
        initContactInfo()
        initPageMenu()
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
                           CNContactPhoneticFamilyNameKey] as [Any]
        
        let contact = try! store.unifiedContact(withIdentifier: contactId!, keysToFetch: keysToFetch as! [CNKeyDescriptor])
        let appContactInfo = App.realm.objects(AppContactInfo.self).filter("identifier == '\(contactId!)'").first
        if contact.imageDataAvailable {
            headPhoto.image = UIImage(data: contact.thumbnailImageData!)
        } else {
            headPhoto.image = R.image.head_photo_default()
        }
        let fullName = contact.familyName + contact.givenName
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
        
        signLabel.text = appContactInfo?.signature
        areaLabel.text = appContactInfo?.area
        if appContactInfo?.age != -1 {
            ageLabel.text = "\(appContactInfo?.age)"
        }
        phones.removeAll()
        for number in contact.phoneNumbers {
            let phoneNumber = (number.value ).stringValue
            phones.append(PhoneUtil.formatPhoneNumber(phoneNumber))
        }
        detailMenuViewController.identifier = contactId
        detailMenuViewController.name = fullName
        detailMenuViewController.phones = phones
        callLogMenuViewController.contactId = contactId
    }
    
    func initPageMenu() {
        let controllerArray : [UIViewController] = [R.storyboard.main.a()! , R.storyboard.main.b()!]
        let parameters: [CAPSPageMenuOption] = [
            .scrollMenuBackgroundColor(UIColor.white),
            .viewBackgroundColor(UIColor.white),
            .selectionIndicatorColor(UIColor(red: 38.0/255.0, green: 173.0/255.0, blue: 86.0/255.0, alpha: 1.0)),
            .selectedMenuItemLabelColor(UIColor(red: 38.0/255.0, green: 173.0/255.0, blue: 86.0/255.0, alpha: 1.0)),
            .unselectedMenuItemLabelColor(UIColor.black),
            .bottomMenuHairlineColor(UIColor(red: 70.0/255.0, green: 70.0/255.0, blue: 80.0/255.0, alpha: 1.0)),
            .centerMenuItems(true),
            .menuItemWidth(Screen.width / 2),
            .menuMargin(0.0)
        ]
        let pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0, y: detailCon.frame.height, width: Screen.width, height: view.frame.height - detailCon.frame.height), pageMenuOptions: parameters)
        addChildViewController(pageMenu)
        view.addSubview(pageMenu.view)
        pageMenu.didMove(toParentViewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func moreFeature(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "编辑联系人", style: .default) { action in
            
            })
        alertController.addAction(UIAlertAction(title: "添加黑名单", style: .default) { action in
            
            })
        alertController.addAction(UIAlertAction(title: "分享", style: .default) { action in
            
            })
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel) { action in
            
            })
        present(alertController, animated: true, completion: nil)
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
