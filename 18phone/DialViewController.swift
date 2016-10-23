//
//  DialViewController.swift
//  18phone
//
//  Created by Kratos on 8/13/16.
//  Copyright © 2016 Kratos. All rights reserved.
//

import UIKit
import Contacts

class DialViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch (indexPath as NSIndexPath).row {
        /// 数字按键要展示的布局
        case 0...8:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.dial_1.identifier, for: indexPath) as! DialNumberCell
            
            if (indexPath as NSIndexPath).row == 0 {
                cell.number.text = "\(indexPath.row + 1)"
            } else {
                cell.number.text = "\(indexPath.row + 1)"
                cell.character.text = characters[indexPath.row - 1]
            }
            cell.effect.tag = indexPath.row + 1
            cell.effect.addTarget(self, action: #selector(clickDialButton(_:)), for: .touchUpInside)
            return cell
        case 10:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.dial_3.identifier, for: indexPath) as! DialNumberCell
            cell.number.text = "0"
            cell.effect.tag = 0
            cell.effect.addTarget(self, action: #selector(clickDialButton(_:)), for: .touchUpInside)
            return cell
            
        /// 添加和删除按键要展示的布局
        case 9:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.dial_2.identifier, for: indexPath) as! DialIconCell
            cell.icon.image = R.image.add_contact()
            cell.effect.addTarget(self, action: #selector(addContact(_:)), for: .touchUpInside)
            
            return cell
        case 11:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.dial_2.identifier, for: indexPath) as! DialIconCell
            cell.icon.image = R.image.delete()
            cell.effect.addTarget(self, action: #selector(backSpace(_:)), for: .touchUpInside)
            
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var temp = numberText.text!
        switch (indexPath as NSIndexPath).row {
        /// 监听数字按键的事件
        case 0...8, 10:
            
            if temp.characters.count < 12 {
                let number = (collectionView.cellForItem(at: indexPath) as!DialNumberCell).number.text!
                temp = temp + number
                numberText.text = temp
                checkNumberArea(temp)
            }
        /// 监听粘贴按键的事件
        case 9:
            
            break
            
        /// 监听删除按键的事件
        case 11:
            
            let length = temp.characters.count
            if length > 0 {
                temp = temp.substring(to: temp.characters.index(temp.startIndex, offsetBy: length - 1))
                numberText.text = temp
                if length == 1 {
                    
                }
                checkNumberArea(temp)
            }
        default:
            break
        }
    }
    
    func checkNumberArea(_ temp: String?) {
        if PhoneUtil.isMobileNumber(temp) || PhoneUtil.isTelephoneNumber(temp) || temp == "10086" {
            PhoneUtil.getPhoneAreaInfo(temp!){ phoneAreaInfo in
                if phoneAreaInfo.errNum == 0 {
                    self.tempArea = (phoneAreaInfo.retData?.province!)! + (phoneAreaInfo.retData?.city!)!
                } else {
                    self.tempArea = "未知归属地"
                }
                self.areaText.text = self.tempArea
                let store = CNContactStore()
                let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                                   CNContactGivenNameKey,
                                   CNContactFamilyNameKey,
                                   CNContactPhoneNumbersKey] as [Any]
                let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor])
                self.isRegister = false
                self.appContactInfo = nil
                try! store.enumerateContacts(with: fetchRequest) { (contact, stop) -> Void in
                    for number in contact.phoneNumbers {
                        
                        let phoneNumber = PhoneUtil.formatPhoneNumber((number.value).stringValue)
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
    
    func clickDialButton(_ sender:UIButton) {
        var temp = numberText.text!
        if temp.characters.count < 12 {
            let number = String(sender.tag)
            temp = temp + number
            numberText.text = temp
            checkNumberArea(temp)
        }
    }
    
    func backSpace(_ sender:UIButton) {
        var temp = numberText.text!
        let length = temp.characters.count
        if length > 0 {
            temp = temp.substring(to: temp.characters.index(temp.startIndex, offsetBy: length - 1))
            numberText.text = temp
            if length == 1 {
                
            }
            checkNumberArea(temp)
        }
    }
    
    func addContact(_ sender: UIButton) {
        if !numberText.text!.isEmpty {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: "新增联系人", style: .default) { action in
                
                })
            alertController.addAction(UIAlertAction(title: "加入到现有的联系人", style: .default) { action in
                
                })
            alertController.addAction(UIAlertAction(title: "取消", style: .cancel) { action in
                
                })
            present(alertController, animated: true, completion: nil)
        }
    }
    
    /**
     拨打按钮监听事件
     
     - parameter sender: 拨打按钮
     */
    @IBAction func call(_ sender: UIButton) {
        if !numberText.text!.isEmpty {
            if PhoneUtil.isMobileNumber(numberText.text) || PhoneUtil.isTelephoneNumber(numberText.text) {
                if isRegister {
                    let outgoingCallViewController = R.storyboard.main.outgoingCallViewController()
                    outgoingCallViewController?.contactId = appContactInfo?.identifier
                    outgoingCallViewController?.toNumber = numberText.text
                    outgoingCallViewController?.contactName = tempName
                    outgoingCallViewController?.phoneArea = tempArea
                    present(outgoingCallViewController!, animated: true, completion: nil)
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
    
    func addCallLog(_ number: String) {
        let callLog = CallLog()
        if appContactInfo != nil {
            callLog.contactId = appContactInfo!.identifier
        }
        if tempName != nil {
            callLog.name = tempName!
        }
        callLog.phone = numberText.text!
        if true {
            callLog.callState = CallState.outConnected.rawValue
        } else {
            callLog.callState = CallState.outUnConnected.rawValue
        }
        callLog.callType = CallType.voice.rawValue
        callLog.callStartTime = Date()
        if tempArea != nil {
            callLog.area = tempArea!
        }
        try! App.realm.write {
            App.realm.add(callLog)
        }
    }
    
    func pasteToShowNumber(_ menu :UIMenuController)
    {
        let paste = UIPasteboard.general
        if PhoneUtil.isNumber(paste.string) {
            numberText.text = paste.string
            checkNumberArea(paste.string)
        }
    }
    
    @IBAction func longPressShowNumberCon(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            showNumberCon.becomeFirstResponder()
            let menu = UIMenuController.shared
            menu.menuItems = [UIMenuItem(title: "粘贴", action:#selector(pasteToShowNumber(_:)))]
            menu.arrowDirection = .up
            let rect = CGRect(x: (Screen.width - 50) / 2, y: showNumberCon.frame.height, width: 50, height: 25)
            menu.setTargetRect(rect, in: showNumberCon)
            menu.setMenuVisible(true, animated: true)
        }
    }
    
}
