//
//  DialViewController.swift
//  bottompopmenu
//
//  Created by Kratos on 7/16/16.
//  Copyright © 2016 Kratos. All rights reserved.
//

import UIKit
import Contacts
import SwiftEventBus


/// 拨号盘控制器
class DialViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    /// 拨号盘的布局对象
    @IBOutlet weak var dialPlateFlowLayout: UICollectionViewFlowLayout!
    
    /// 拨号盘按键部分
    @IBOutlet weak var dialPlate: UICollectionView!
    
    /// 拨号盘显示号码部分
    @IBOutlet weak var dialNumber: UILabel!
    
    /// 拨号盘显示号码的容器
    @IBOutlet weak var dialNumberCon: UIView!
    
    /// 用于查询后保存的号码归属地
    var tempArea: String?
    
    /// 用于查询后保存的联系人姓名
    var tempName: String?
    
    /// 拨号按钮框
    var callConView: CallConView?
    
    /// 拨号盘数字按键上的字母
    let characters = ["ABC", "DEF", "GHI", "JKL", "MNO", "PQRS", "TUV", "WXYZ"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dialPlateFlowLayout.itemSize.width = (Screen.width - 4) / 3
//        callConView = R.nib.callConView.firstView(self)
//        let callConViewWidth = Screen.width / 3
//        callConView?.frame = CGRect(x: (Screen.width - callConViewWidth) / 2, y: (Screen.height - (callConView?.frame.height)!), width: callConViewWidth, height: (callConView?.frame.height)!)
//        callConView?.delegate = self
//        App.application.keyWindow?.addSubview(callConView!)
        SwiftEventBus.onMainThread(self, name: "hideCallCon") { result in
            self.hideCallCon()
        }
        SwiftEventBus.onMainThread(self, name: "showCallCon") { result in
            self.showCallCon()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("DialViewController viewWillDisappear")
        callConView?.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("DialViewController viewDidDisappear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !dialNumber.text!.isEmpty {
            callConView?.isHidden = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        switch (indexPath as NSIndexPath).row {
//            /// 数字按键要展示的布局
//        case 0...8, 10:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.dial_a.identifier, for: indexPath) as! DialNumberCell
//            
//            if (indexPath as NSIndexPath).row == 0 {
//                cell.number.text = "\(indexPath.row + 1)"
//            } else if (indexPath as NSIndexPath).row == 10 {
//                cell.number.text = "0"
//            } else {
//                cell.number.text = "\(indexPath.row + 1)"
//                cell.character.text = characters[indexPath.row - 1]
//            }
//            return cell
//            /// 粘贴和删除按键要展示的布局
//        case 9, 11:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.dial_b.identifier, for: indexPath) as! DialIconCell
//            if (indexPath as NSIndexPath).row == 9 {
//                cell.icon.image = R.image.paste()
//                cell.hint.text = "粘贴"
//            }else{
//                cell.icon.image = R.image.delete()
//                cell.hint.text = "删除"
//            }
//            
//            return cell
//        default:
//            return UICollectionViewCell()
//        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch (indexPath as NSIndexPath).row {
            /// 监听数字按键的事件
        case 0...8, 10:
            var temp = dialNumber.text
            if temp!.characters.count < 12 {
                dialNumberCon.isHidden = false
                callConView?.isHidden = false
                let number = (collectionView.cellForItem(at: indexPath) as!DialNumberCell).number.text
                temp = temp! + number!
                dialNumber.text = temp
                if PhoneUtil.isMobileNumber(temp) || PhoneUtil.isTelephoneNumber(temp) || temp == "10086" {
                    PhoneUtil.getPhoneAreaInfo(temp!){ phoneAreaInfo in
                        if phoneAreaInfo.errNum == 0 {
                            self.tempArea = (phoneAreaInfo.retData?.province!)! + "-" + (phoneAreaInfo.retData?.city!)!
                        } else {
                            self.tempArea = "未知归属地"
                        }
                        
                        
                    }
                }
            }
            /// 监听粘贴按键的事件
        case 9:
            let paste = UIPasteboard.general
            if PhoneUtil.isNumber(paste.string) {
                dialNumber.text = paste.string
                dialNumberCon.isHidden = false
                callConView?.isHidden = false
            } else {
                
            }
            /// 监听删除按键的事件
        case 11:
            var temp = dialNumber.text!
            let length = temp.characters.count
            if length > 0 {
                temp = temp.substring(to: temp.characters.index(temp.startIndex, offsetBy: length - 1))
                dialNumber.text = temp
                if length == 1 {
                    dialNumberCon.isHidden = true
                    callConView?.isHidden = true
                }
            }
        default:
            break
        }
    }
    
    /**
     拨打按钮监听事件
     
     - parameter sender: 拨打按钮
     */
    @IBAction func call(_ sender: UIButton) {
        if PhoneUtil.isMobileNumber(dialNumber.text) || PhoneUtil.isTelephoneNumber(dialNumber.text) {
            UIApplication.shared.openURL(Foundation.URL(string: "tel://" + dialNumber.text!)!)
            
        } else {
            UIApplication.shared.openURL(Foundation.URL(string: "tel://" + dialNumber.text!)!)
        }
        let callLog = CallLog()
        callLog.name = "James"
        callLog.phone = dialNumber.text!
        //callLog.callState = CallState.In.rawValue
        callLog.callStartTime = Date()
        if tempArea != nil {
            callLog.area = tempArea!
        }
        try! App.realm.write {
            App.realm.add(callLog)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor.groupTableViewBackground
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor.white
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func hideCallCon() {
        callConView?.isHidden = true
    }
    
    func showCallCon() {
        if !dialNumber.text!.isEmpty {
            callConView?.isHidden = false
        }
    }
}
