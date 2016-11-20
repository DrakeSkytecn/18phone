//
//  DialViewController.swift
//  18phone
//
//  Created by Kratos on 8/13/16.
//  Copyright © 2016 Kratos. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import SwiftEventBus
import Async

class DialViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var callId: String?
    
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
    
    var pending: UIAlertController?
    
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
        SwiftEventBus.onMainThread(self, name: "getBackCallDuration") { result in
            self.pending?.dismiss(animated: false, completion: nil)
            if self.callId != nil {
                
                PhoneUtil.getBackCallDuration(self.callId!)
                //self.addCallLog(self.numberText.text!)
                self.callId = nil
            }
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("DialViewController viewDidDisappear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("DialViewController viewWillDisappear")
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
    
    func checkNumberArea(_ temp: String) {
        if PhoneUtil.isMobileNumber(temp) {
            //先查是否为通讯录联系人
            let store = CNContactStore()
            let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                               CNContactGivenNameKey,
                               CNContactFamilyNameKey,
                               CNContactPhoneNumbersKey] as [Any]
            let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor])
            isRegister = false
            appContactInfo = nil
            
            try! store.enumerateContacts(with: fetchRequest) { contact, stop -> Void in
                for number in contact.phoneNumbers {
                    let phoneNumber = PhoneUtil.formatPhoneNumber((number.value).stringValue)
                    if phoneNumber == temp {
                        print("phoneNumber:\(phoneNumber)")
                        self.tempName = contact.familyName + contact.givenName
                        print("self.tempName:\(self.tempName)")
                        //                        self.areaText.text = self.tempName
                        self.appContactInfo = App.realm.objects(AppContactInfo.self).filter("identifier == '\(contact.identifier)'").first!
                        if self.appContactInfo != nil && self.appContactInfo!.accountId.isEmpty {
                            APIUtil.getContactID(phoneNumber, callBack: { contactIDInfo in
                                if contactIDInfo.codeStatus == 1 {
                                    try! App.realm.write {
                                        self.appContactInfo!.accountId = contactIDInfo.userID!
                                        self.appContactInfo!.isRegister = contactIDInfo.isRegister!
                                    }
                                    self.isRegister = contactIDInfo.isRegister!
                                }
                            })
                        }
                        break
                    }
                }
            }
            
            // 然后查号码归属地，本地查不到就通过接口查询并保存
            if let area = App.realm.objects(Area.self).filter("key == '\(temp)'").first {
                tempArea = area.name
                if tempArea!.isEmpty || tempArea == "未知" {
                    PhoneUtil.getPhoneAreaInfo(temp){ phoneAreaInfo in
                        if phoneAreaInfo.errNum == 0 {
                            let province = phoneAreaInfo.retData!.province!
                            let city = phoneAreaInfo.retData!.city!
                            let fullArea = province + city
                            switch province {
                            case "北京", "上海", "天津", "重庆":
                                self.tempArea = province
                                break
                            default:
                                self.tempArea = fullArea
                                break
                            }
                        } else {
                            self.tempArea = "未知"
                        }
                        if self.tempName == nil {
                            self.areaText.text = self.tempArea
                        } else {
                            self.areaText.text = self.tempName
                        }
                        try! App.realm.write {
                            area.name = self.tempArea!
                        }
                    }
                } else {
                    if tempName == nil {
                        areaText.text = tempArea
                    } else {
                        areaText.text = tempName
                    }
                }
            } else {
                PhoneUtil.getPhoneAreaInfo(temp){ phoneAreaInfo in
                    if phoneAreaInfo.errNum == 0 {
                        let province = phoneAreaInfo.retData!.province!
                        let city = phoneAreaInfo.retData!.city!
                        let fullArea = province + city
                        switch province {
                        case "北京", "上海", "天津", "重庆":
                            self.tempArea = province
                            break
                        default:
                            self.tempArea = fullArea
                            break
                        }
                    } else {
                        self.tempArea = "未知"
                    }
                    if self.tempName == nil {
                        self.areaText.text = self.tempArea
                    } else {
                        self.areaText.text = self.tempName
                    }
                    let area = Area()
                    area.key = temp
                    area.name = self.tempArea!
                    try! App.realm.write {
                        App.realm.add(area)
                    }
                }
            }
        } else {
            tempArea = ""
            tempName = nil
            areaText.text = nil
            nameText.text = nil
            appContactInfo = nil
            isRegister = false
        }
    }
    
    func checkIs18User(_ phoneNumber: String) {
        
    }
    
    func clickDialButton(_ sender:UIButton) {
        var temp = numberText.text!
        if temp.characters.count < 12 {
            let number = String(sender.tag)
            temp = temp + number
            numberText.text = temp
            checkNumberArea(temp)
            checkIs18User(temp)
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
            if PhoneUtil.isMobileNumber(numberText.text) {
                if  appContactInfo != nil && !appContactInfo!.accountId.isEmpty {
                    let outgoingCallViewController = R.storyboard.main.outgoingCallViewController()
                    let callLog = CallLog()
                    callLog.accountId = appContactInfo!.accountId
                    callLog.contactId = appContactInfo!.identifier
                    print("appContactInfo!.accountId:\(appContactInfo!.accountId)")
                    callLog.phone = numberText.text!
                    callLog.name = tempName!
                    callLog.area = tempArea!
                    callLog.callStartTime = Date()
                    callLog.callType = CallType.voice.rawValue
                    outgoingCallViewController?.callLog = callLog
                    present(outgoingCallViewController!, animated: true, completion: nil)
                } else {
                    if let saveUsername = UserDefaults.standard.string(forKey: "username") {
                        pending = UIAlertController(title: "回拨电话", message: "正在拨号中，您将收到一通回拨电话，接听等待即可通话", preferredStyle: .alert)
                        let indicator = UIActivityIndicatorView(frame: pending!.view.bounds)
                        indicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                        pending?.view.addSubview(indicator)
                        pending?.addAction(UIAlertAction(title: "挂断", style: .cancel) { action in
                            if self.callId != nil {
                                PhoneUtil.hangupBackCall(self.callId!, callBack: { dialBackCallInfo in
                                    if dialBackCallInfo.status == "0" {
                                        self.pending?.dismiss(animated: true, completion: nil)
                                    }
                                })
                            }
                        })
                        present(pending!, animated: true, completion: nil)
                        PhoneUtil.dialBackCall(saveUsername, toNumber: numberText.text!, callBack: { dialBackCallInfo in
                            if dialBackCallInfo.status == "0" {
                                self.callId = dialBackCallInfo.callId
                            }
                        })
                    }
//                    addCallLog(numberText.text!)
                }
            } else if PhoneUtil.isTelephoneNumber(numberText.text) {
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
            checkNumberArea(paste.string!)
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
