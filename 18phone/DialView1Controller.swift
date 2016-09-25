//
//  DialView1Controller.swift
//  18phone
//
//  Created by Kratos on 8/13/16.
//  Copyright © 2016 Kratos. All rights reserved.
//

import UIKit
import Contacts

class DialView1Controller: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var showNumberCon: UIView!
    
    @IBOutlet weak var dialCollectionView: UICollectionView!
    
    /// 新增联系人按钮
    @IBOutlet weak var addContactBtn: UIButton!
    
    /// 显示号码
    @IBOutlet weak var numberText: UILabel!
    
    /// 显示号码归属地
    @IBOutlet weak var areaText: UILabel!
    
    /// 显示姓名
    @IBOutlet weak var nameText: UILabel!
    
    /// 用于查询后保存的号码归属地
    var tempArea: String?
    
    /// 用于查询后保存的联系人姓名
    var tempName: String?
    
    /// 拨号盘数字按键上的字母
    let characters = ["ABC", "DEF", "GHI", "JKL", "MNO", "PQRS", "TUV", "WXYZ"]
    
    var isRegister = false
    
    var appContactInfo: AppContactInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dialCollectionView.scrollsToTop = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        /// 数字按键要展示的布局
        case 0...8:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(R.reuseIdentifier.dial_1.identifier, forIndexPath: indexPath) as! DialNumberCell
            
            if indexPath.row == 0 {
                cell.number.text = "\(indexPath.row + 1)"
            } else {
                cell.number.text = "\(indexPath.row + 1)"
                cell.character.text = characters[indexPath.row - 1]
            }
            cell.effect.tag = indexPath.row + 1
            cell.effect.addTarget(self, action: #selector(clickDialButton(_:)), forControlEvents: .TouchUpInside)
            return cell
        case 10:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(R.reuseIdentifier.dial_3.identifier, forIndexPath: indexPath) as! DialNumberCell
            cell.number.text = "0"
            cell.effect.tag = 0
            cell.effect.addTarget(self, action: #selector(clickDialButton(_:)), forControlEvents: .TouchUpInside)
            return cell
            
        /// 粘贴和删除按键要展示的布局
        case 9:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(R.reuseIdentifier.dial_2.identifier, forIndexPath: indexPath) as! DialIconCell
            cell.icon.image = R.image.paste()
            //cell.effect.addTarget(self, action: #selector(clickDialButton(_:)), forControlEvents: .TouchUpInside)
            
            return cell
        case 11:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(R.reuseIdentifier.dial_2.identifier, forIndexPath: indexPath) as! DialIconCell
            cell.icon.image = R.image.delete()
            cell.effect.addTarget(self, action: #selector(backSpace(_:)), forControlEvents: .TouchUpInside)
            
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var temp = numberText.text
        switch indexPath.row {
        /// 监听数字按键的事件
        case 0...8, 10:
            
            if temp?.characters.count < 12 {
                //addContactBtn.hidden = false
                let number = (collectionView.cellForItemAtIndexPath(indexPath) as!DialNumberCell).number.text
                temp = temp! + number!
                numberText.text = temp
                checkNumberArea(temp)
            }
        /// 监听粘贴按键的事件
        case 9:
            
            break
            
        /// 监听删除按键的事件
        case 11:
            
            let length = temp?.characters.count
            if length > 0 {
                temp = temp?.substringToIndex(temp!.startIndex.advancedBy(length! - 1))
                numberText.text = temp
                if length == 1 {
                    //addContactBtn.hidden = true
                }
                checkNumberArea(temp)
            }
        default:
            break
        }
    }
    
    func checkNumberArea(temp: String?) {
        if PhoneUtil.isMobileNumber(temp) || PhoneUtil.isTelephoneNumber(temp) || temp == "10086" {
            PhoneUtil.getPhoneAreaInfo(temp!){ phoneAreaInfo in
                if phoneAreaInfo.errNum == 0 {
                    self.tempArea = (phoneAreaInfo.retData?.province!)! + (phoneAreaInfo.retData?.city!)!
                } else {
                    self.tempArea = "未知归属地"
                }
                self.areaText.text = self.tempArea
                let store = CNContactStore()
                let keysToFetch = [CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName),
                                   CNContactGivenNameKey,
                                   CNContactFamilyNameKey,
                                   CNContactPhoneNumbersKey]
                let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)
                self.isRegister = false
                self.appContactInfo = nil
                try! store.enumerateContactsWithFetchRequest(fetchRequest) { (let contact, let stop) -> Void in
                    for number in contact.phoneNumbers {
                        
                        let phoneNumber = PhoneUtil.formatPhoneNumber((number.value as! CNPhoneNumber).stringValue)
                        if phoneNumber == temp {
                            print("phoneNumber:\(phoneNumber)")
                            self.tempName = contact.familyName + contact.givenName
                            print("self.tempName:\(self.tempName)")
                            self.nameText.text = self.tempName
                            self.appContactInfo = App.realm.objects(AppContactInfo.self).filter("identifier == '\(contact.identifier)'").first
                            if self.appContactInfo != nil {
                                self.isRegister = self.appContactInfo!.isRegister
                            }
                            return
                        }
                    }
                }
            }
        } else {
            tempArea = "未知归属地"
            tempName = nil
            areaText.text = nil
            nameText.text = nil
            appContactInfo = nil
            isRegister = false
        }
    }
    
    func clickDialButton(sender:UIButton) {
        var temp = numberText.text
        if temp?.characters.count < 12 {
            let number = String(sender.tag)
            temp = temp! + number
            numberText.text = temp
            checkNumberArea(temp)
        }
    }
    
    func backSpace(sender:UIButton) {
        var temp = numberText.text
        let length = temp?.characters.count
        if length > 0 {
            temp = temp?.substringToIndex(temp!.startIndex.advancedBy(length! - 1))
            numberText.text = temp
            if length == 1 {
                //addContactBtn.hidden = true
            }
            checkNumberArea(temp)
        }
    }
    
    @IBAction func addContact(sender: UIButton) {
        
    }
    
    /**
     拨打按钮监听事件
     
     - parameter sender: 拨打按钮
     */
    @IBAction func call(sender: UIButton) {
        if !numberText.text!.isEmpty {
            if PhoneUtil.isMobileNumber(numberText.text) || PhoneUtil.isTelephoneNumber(numberText.text) {
                if isRegister {
                    let outgoingCallViewController = R.storyboard.main.outgoingCallViewController()
                    outgoingCallViewController?.contactId = appContactInfo?.identifier
                    outgoingCallViewController?.toNumber = numberText.text
                    outgoingCallViewController?.contactName = tempName
                    outgoingCallViewController?.phoneArea = tempArea
                    presentViewController(outgoingCallViewController!, animated: true, completion: nil)
                } else {
                    PhoneUtil.callSystemPhone(numberText.text!)
                    addCallLog(numberText.text!)
                }
            } else {
                PhoneUtil.callSystemPhone(numberText.text!)
                addCallLog(numberText.text!)
            }
        }
    }
    
    func addCallLog(number: String) {
        let callLog = CallLog()
        if appContactInfo != nil {
            callLog.identifier = appContactInfo!.identifier
        }
        if tempName != nil {
            callLog.name = tempName!
        }
        callLog.phone = numberText.text!
        if true {
            callLog.callState = CallState.OutConnected.rawValue
        } else {
            callLog.callState = CallState.OutUnConnected.rawValue
        }
        callLog.callType = CallType.Voice.rawValue
        callLog.callStartTime = NSDate()
        if tempArea != nil {
            callLog.area = tempArea!
        }
        try! App.realm.write {
            App.realm.add(callLog)
        }
    }
    
    func pasteToShowNumber(menu :UIMenuController)
    {
        let paste = UIPasteboard.generalPasteboard()
        if PhoneUtil.isNumber(paste.string) {
            numberText.text = paste.string
            checkNumberArea(paste.string)
        }
    }
    
    @IBAction func longPressShowNumberCon(sender: UILongPressGestureRecognizer) {
        if sender.state == .Began {
            showNumberCon.becomeFirstResponder()
            let menu = UIMenuController.sharedMenuController()
            menu.menuItems = [UIMenuItem(title: "粘贴", action:#selector(pasteToShowNumber(_:)))]
            menu.arrowDirection = .Up
            let rect = CGRectMake((Screen.width - 50) / 2, showNumberCon.frame.height, 50, 25)
            menu.setTargetRect(rect, inView: showNumberCon)
            menu.setMenuVisible(true, animated: true)
        }
    }
    
}
