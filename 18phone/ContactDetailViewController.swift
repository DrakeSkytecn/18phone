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
    
    @IBOutlet weak var headPhoto: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var sexImage: UIImageView!
    
    @IBOutlet weak var signLabel: UILabel!
    
    @IBOutlet weak var areaLabel: UILabel!
    
    @IBOutlet weak var ageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(contactId)
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
        // Do any additional setup after loading the view.
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
