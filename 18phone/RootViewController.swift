//
//  ViewController.swift
//  bottompopmenu
//
//  Created by Kratos on 7/9/16.
//  Copyright © 2016 Kratos. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import SwiftEventBus

/// 拨号页面根控制器
class RootViewController: UIViewController, GSAccountDelegate {
    
    let topIcons = [R.image.delete_all(), R.image.backup()]
    
    @IBOutlet weak var menuHeight: NSLayoutConstraint!
    
    @IBOutlet weak var menuY: NSLayoutConstraint!
    
    /// 用于判断拨号盘是否展开
    fileprivate var isMenuShow: Bool = false
    
    /// 用于判断拨号页面是否显示
    fileprivate var isViewHidden: Bool = false
    
    /// 显示免费通话剩余天数
    @IBOutlet weak var dayLeftItem: UIBarButtonItem!
    
    /// 拨号盘
    @IBOutlet weak var menuView: UIView!
    
    /// 通话子页容器
    @IBOutlet weak var aContainer: UIView!
    
    /// 通讯录子页容器
    @IBOutlet weak var bContainer: UIView!
    
    /// 通话记录控制器实例
    var callLogViewController: CallLogViewController?
    
    /// 通讯录控制器实例
    var contactViewController: ContactViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem?.image = topIcons[0]
        menuHeight.constant = Screen.height - 49
        menuY.constant = menuHeight.constant - 20
        App.userAgentAccount?.delegate = self
        App.userAgentAccount?.addObserver(self, forKeyPath: "status", options: .initial, context: nil)
        App.userAgentAccount?.connect()
        if let userID = UserDefaults.standard.string(forKey: "userID") {
            APIUtil.getDayLeft(userID, callBack: { dayLeft in
                if let day = dayLeft.day {
                    self.dayLeftItem.title = String(describing: day)
                }
            })
        }
//        SwiftEventBus.onMainThread(self, name: "newContact", handler: { result in
//            self.newContact(phoneNumber: result.object as! String)
//        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        isViewHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        isViewHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        App.userAgentAccount?.disconnect()
    }
    
    /**
     调用这个方法会根据当前拨号盘的状态来决定展开还是收起拨号盘
     
     - parameter item: 选中的底部子菜单项
     */
    func changeMenuState(_ item: UITabBarItem) {
        print("changeMenuState")
        if !isViewHidden {
            if isMenuShow {
                hide()
            } else {
                show()
            }
        }
    }
    
    /**
     展开拨号盘
     */
    fileprivate func show() {
        navigationController?.setNavigationBarHidden(true, animated: true)
        menuTranYAnimation(-menuView.frame.height)
        isMenuShow = true
    }
    
    /**
     收起拨号盘
     */
    fileprivate func hide() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        menuTranYAnimation(menuView.frame.height)
        isMenuShow = false
    }
    
    /**
     无动画效果地重置拨号盘到初始位置
     
     - parameter height: 移动的距离，默认传入拨号盘的高度
     */
    fileprivate func resetMenuY(_ height: CGFloat) {
        var rect = menuView.frame
        rect.origin.y = rect.origin.y + height
        menuView.frame = rect
        menuY.constant = menuY.constant + height
    }
    
    /**
     动画效果移动拨号盘的位置
     
     - parameter height: 移动的距离，默认传入拨号盘的高度
     */
    fileprivate func menuTranYAnimation(_ height: CGFloat) {
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: {
            self.resetMenuY(height)
            }, completion: nil)
    }
    
    /**
     顶部分页导航监听事件
     
     - parameter sender: 被点击的分页导航控件
     */
    @IBAction func topMenuNav(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            aContainer.isHidden = false
            bContainer.isHidden = true
            callLogViewController?.scrollsToTopEnable(true)
            contactViewController?.scrollsToTopEnable(false)
            navigationItem.leftBarButtonItem?.image = topIcons[0]
            break
        case 1:
            aContainer.isHidden = true
            bContainer.isHidden = false
            callLogViewController?.scrollsToTopEnable(false)
            contactViewController?.scrollsToTopEnable(true)
            navigationItem.leftBarButtonItem?.image = topIcons[1]
            break
        default:
            break
        }
    }
    
    @IBAction func leftMenu(_ sender: UIBarButtonItem) {
        if navigationItem.leftBarButtonItem?.image == topIcons[0] {
            let callLogs = App.realm.objects(CallLog.self)
            if callLogs.count != 0 {
                let alertController = UIAlertController(title: "清空通话记录", message: "此操作不可撤回，确认清除所有的通话记录吗？", preferredStyle: .actionSheet)
                alertController.addAction(UIAlertAction(title: "确认", style: .destructive) { action in
                    SwiftEventBus.post("deleteAllCallLogs")
                    SwiftEventBus.post("showCallCon")
                    })
                alertController.addAction(UIAlertAction(title: "取消", style: .cancel) { action in
                    SwiftEventBus.post("showCallCon")
                    })
                present(alertController, animated: true, completion: nil)
            }
        } else {
            navigationController?.pushViewController(R.storyboard.main.backupViewController()!, animated: true)
        }
    }
    
    @IBAction func scanQRCode(_ sender: UIBarButtonItem) {
        let qrCodeViewController = QRCodeViewController()
        navigationController?.pushViewController(qrCodeViewController, animated: true)
    }
    
    @IBAction func toUserCenter(_ sender: UIBarButtonItem) {
        
    }
    
//    func newContact(phoneNumber: String) {
//        let contact = CNMutableContact()
//        contact.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberMobile, value: CNPhoneNumber(stringValue: phoneNumber))]
//        let contactViewController = CNContactViewController(forNewContact: contact)
//        self.navigationController?.pushViewController(contactViewController, animated: true)
//    }
    
    func statusDidChange() {
        switch App.userAgentAccount!.status {
        case GSAccountStatusOffline:
            print("Offline")
            break
        case GSAccountStatusConnecting:
            print("Connecting")
            
            break
        case GSAccountStatusConnected:
            print("Connected")
            break
        case GSAccountStatusDisconnecting:
            print("Disconnecting")
            break
        default:
            break
        }
    }
    
    func didReceiveIncomingCall(_ callData: [AnyHashable: Any]!) {
        let account = callData["account"] as! GSAccount
        let inCall = callData["inCall"] as! GSCall
        let vid_cnt = callData["vid_cnt"] as! Int
        print("vid_cnt:\(vid_cnt)")
        if vid_cnt == 0 {
            let incomingCallViewController = R.storyboard.main.incomingCallViewController()
            incomingCallViewController?.inCall = inCall
            present(incomingCallViewController!, animated: true, completion: nil)
        } else {
            let incomingVideoViewController = R.storyboard.main.incomingVideoViewController()
            incomingVideoViewController!.inCall = inCall
            present(incomingVideoViewController!, animated: true, completion: nil)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            statusDidChange()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier =  segue.identifier {
            switch identifier {
            case R.segue.rootViewController.callLogViewController.identifier:
                callLogViewController = segue.destination as? CallLogViewController
                break
            case R.segue.rootViewController.contactViewController.identifier:
                contactViewController = segue.destination as? ContactViewController
                break
            default:
                break
            }
        }
        
    }
    
    deinit {
        App.userAgentAccount?.disconnect()
    }
}

