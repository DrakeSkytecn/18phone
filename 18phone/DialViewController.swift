//
//  DialViewController.swift
//  bottompopmenu
//
//  Created by Kratos on 7/16/16.
//  Copyright © 2016 Kratos. All rights reserved.
//

import UIKit
import RealmSwift

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
    
    /// 用于判断拨号按钮框是否显示
    var isCallConViewShow = false
    
    /// 拨号按钮框
    var callConView: CallConView?
    
    /// 拨号盘数字按键上的字母
    let characters = ["ABC", "DEF", "GHI", "JKL", "MNO", "PQRS", "TUV", "WXYZ"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dialPlateFlowLayout.itemSize.width = (Screen.width - 4) / 3
        callConView = R.nib.callConView.firstView(owner: self)
        let callConViewWidth = Screen.width / 3
        callConView?.frame = CGRectMake((Screen.width - callConViewWidth) / 2, (Screen.height - (callConView?.frame.height)!), callConViewWidth, (callConView?.frame.height)!)
        callConView?.delegate = self
        App.application.keyWindow?.addSubview(callConView!)
    }
    
    override func viewWillDisappear(animated: Bool) {
        print("DialViewController viewWillDisappear")
        isCallConViewShow = false
        callConView?.hidden = true
    }
    
    override func viewDidDisappear(animated: Bool) {
        print("DialViewController viewDidDisappear")
    }
    
    override func viewDidAppear(animated: Bool) {
        if !dialNumber.text!.isEmpty {
            isCallConViewShow = true
            callConView?.hidden = false
        }
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
        case 0...8, 10:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(R.reuseIdentifier.dial_a.identifier, forIndexPath: indexPath) as! DialNumberCell
            
            if indexPath.row == 0 {
                cell.number.text = "\(indexPath.row + 1)"
            } else if indexPath.row == 10 {
                cell.number.text = "0"
            } else {
                cell.number.text = "\(indexPath.row + 1)"
                cell.character.text = characters[indexPath.row - 1]
            }
            return cell
            /// 粘贴和删除按键要展示的布局
        case 9, 11:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(R.reuseIdentifier.dial_b.identifier, forIndexPath: indexPath) as! DialIconCell
            if indexPath.row == 9 {
                cell.icon.image = R.image.paste()
                cell.hint.text = "粘贴"
            }else{
                cell.icon.image = R.image.delete()
                cell.hint.text = "删除"
            }
            
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
            /// 监听数字按键的事件
        case 0...8, 10:
            var temp = dialNumber.text
            if temp?.characters.count < 12 {
                dialNumberCon.hidden = false
                callConView?.hidden = false
                let number = (collectionView.cellForItemAtIndexPath(indexPath) as!DialNumberCell).number.text
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
            let paste = UIPasteboard.generalPasteboard()
            if PhoneUtil.isNumber(paste.string) {
                dialNumber.text = paste.string
                dialNumberCon.hidden = false
                callConView?.hidden = false
                isCallConViewShow = true
            } else {
                
            }
            /// 监听删除按键的事件
        case 11:
            var temp = dialNumber.text
            let length = temp?.characters.count
            if length > 0 {
                temp = temp?.substringToIndex(temp!.startIndex.advancedBy(length! - 1))
                dialNumber.text = temp
                if length == 1 {
                    dialNumberCon.hidden = true
                    callConView?.hidden = true
                    isCallConViewShow = false
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
    @IBAction func call(sender: UIButton) {
        if PhoneUtil.isMobileNumber(dialNumber.text) || PhoneUtil.isTelephoneNumber(dialNumber.text) {
            UIApplication.sharedApplication().openURL(NSURL(string: "tel://" + dialNumber.text!)!)
            
        } else {
            UIApplication.sharedApplication().openURL(NSURL(string: "tel://" + dialNumber.text!)!)
        }
        let callLog = CallLog()
        callLog.name = "James"
        callLog.phone = dialNumber.text!
        callLog.callState = 0
        callLog.callStartTime = DateUtil.getCurrentDate()
        if tempArea != nil {
            callLog.area = tempArea!
        }
        let realm = try! Realm()
        try! realm.write {
            realm.add(callLog)
        }
    }
    
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.cellForItemAtIndexPath(indexPath)?.backgroundColor = UIColor.groupTableViewBackgroundColor()
    }
    
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.cellForItemAtIndexPath(indexPath)?.backgroundColor = UIColor.whiteColor()
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
