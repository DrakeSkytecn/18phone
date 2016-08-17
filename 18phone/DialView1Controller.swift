//
//  DialView1Controller.swift
//  18phone
//
//  Created by Kratos on 8/13/16.
//  Copyright © 2016 Kratos. All rights reserved.
//

import UIKit

class DialView1Controller: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    /// 新增联系人按钮
    @IBOutlet weak var addContactBtn: UIButton!
    
    /// 显示号码
    @IBOutlet weak var numberText: UILabel!
    
    /// 显示号码归属地
    @IBOutlet weak var areaText: UILabel!
    
    /// 用于查询后保存的号码归属地
    var tempArea: String?
    
    /// 用于查询后保存的联系人姓名
    var tempName: String?
    
    /// 拨号盘数字按键上的字母
    let characters = ["ABC", "DEF", "GHI", "JKL", "MNO", "PQRS", "TUV", "WXYZ"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
            return cell
        case 10:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(R.reuseIdentifier.dial_3.identifier, forIndexPath: indexPath) as! DialNumberCell
            cell.number.text = "0"
            return cell
        /// 粘贴和删除按键要展示的布局
        case 9, 11:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(R.reuseIdentifier.dial_2.identifier, forIndexPath: indexPath) as! DialIconCell
            if indexPath.row == 9 {
                cell.icon.image = R.image.paste()
            }else{
                cell.icon.image = R.image.delete()
            }
            
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
                addContactBtn.hidden = false
                let number = (collectionView.cellForItemAtIndexPath(indexPath) as!DialNumberCell).number.text
                temp = temp! + number!
                numberText.text = temp
                checkNumberArea(temp)
            }
        /// 监听粘贴按键的事件
        case 9:
            
            let paste = UIPasteboard.generalPasteboard()
            if PhoneUtil.isNumber(paste.string) {
                numberText.text = paste.string
                addContactBtn.hidden = false
            } else {
                
            }
        /// 监听删除按键的事件
        case 11:
            
            let length = temp?.characters.count
            if length > 0 {
                temp = temp?.substringToIndex(temp!.startIndex.advancedBy(length! - 1))
                numberText.text = temp
                if length == 1 {
                    addContactBtn.hidden = true
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
                    self.tempArea = (phoneAreaInfo.retData?.province!)! + "-" + (phoneAreaInfo.retData?.city!)!
                    self.areaText.text = self.tempArea
                } else {
                    self.tempArea = "未知归属地"
                }
            }
        } else {
            tempArea = "未知归属地"
            areaText.text = nil
        }
    }
    
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.cellForItemAtIndexPath(indexPath)?.backgroundColor = UIColor.groupTableViewBackgroundColor()
    }
    
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.cellForItemAtIndexPath(indexPath)?.backgroundColor = UIColor.clearColor()
    }
    
    @IBAction func addContact(sender: UIButton) {
        
    }
    
    /**
     拨打按钮监听事件
     
     - parameter sender: 拨打按钮
     */
    @IBAction func call(sender: UIButton) {
        if PhoneUtil.isMobileNumber(numberText.text) || PhoneUtil.isTelephoneNumber(numberText.text) {

            
//            UIApplication.sharedApplication().openURL(NSURL(string: "tel://" + numberText.text!)!)
            
        } else {
//            UIApplication.sharedApplication().openURL(NSURL(string: "tel://" + numberText.text!)!)
        }
        
        let outgoingCallViewController = R.storyboard.main.outgoingCallViewController()
        outgoingCallViewController?.toNumber = numberText.text
        outgoingCallViewController?.contactName = "James"
        outgoingCallViewController?.phoneArea = tempArea
        presentViewController(outgoingCallViewController!, animated: true, completion: nil)
        
    }
}
