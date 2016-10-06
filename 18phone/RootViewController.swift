//
//  ViewController.swift
//  bottompopmenu
//
//  Created by Kratos on 7/9/16.
//  Copyright © 2016 Kratos. All rights reserved.
//

import UIKit

/// 拨号页面根控制器
class RootViewController: UIViewController, GSAccountDelegate {
    
    @IBOutlet weak var menuHeight: NSLayoutConstraint!
    
    @IBOutlet weak var menuY: NSLayoutConstraint!
    
    /// 用于判断拨号盘是否展开
    private var isMenuShow: Bool = false
    
    /// 用于判断拨号页面是否显示
    private var isViewHidden: Bool = false
    
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
        menuHeight.constant = Screen.height - 49
        menuY.constant = menuHeight.constant - 20
        App.userAgentAccount.delegate = self
        App.userAgentAccount.addObserver(self, forKeyPath: "status", options: .Initial, context: nil)
        App.userAgentAccount.connect()
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func viewDidAppear(animated: Bool) {
        isViewHidden = false
    }
    
    override func viewDidDisappear(animated: Bool) {
        isViewHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        App.userAgentAccount.disconnect()
    }
    
    /**
     调用这个方法会根据当前拨号盘的状态来决定展开还是收起拨号盘
     
     - parameter item: 选中的底部子菜单项
     */
    func changeMenuState(item: UITabBarItem) {
        print("changeMenuState")
        if !isViewHidden {
            if isMenuShow {
                hide()
                //                item.selectedImage = R.image.dial_up()
                //                item.title = "展开"
            } else {
                show()
                //                item.selectedImage = R.image.dial_down()
                //                item.title = "收起"
            }
        }
    }
    
    /**
     展开拨号盘
     */
    private func show() {
        navigationController?.setNavigationBarHidden(true, animated: true)
        menuTranYAnimation(-menuView.frame.height)
        isMenuShow = true
    }
    
    /**
     收起拨号盘
     */
    private func hide() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        menuTranYAnimation(menuView.frame.height)
        isMenuShow = false
    }
    
    /**
     无动画效果地重置拨号盘到初始位置
     
     - parameter height: 移动的距离，默认传入拨号盘的高度
     */
    private func resetMenuY(height: CGFloat) {
        var rect = menuView.frame
        rect.origin.y = rect.origin.y + height
        menuView.frame = rect
        menuY.constant = menuY.constant + height
    }
    
    /**
     动画效果移动拨号盘的位置
     
     - parameter height: 移动的距离，默认传入拨号盘的高度
     */
    private func menuTranYAnimation(height: CGFloat) {
        UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.resetMenuY(height)
            }, completion: nil)
    }
    
    /**
     顶部分页导航监听事件
     
     - parameter sender: 被点击的分页导航控件
     */
    @IBAction func topMenuNav(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            aContainer.hidden = false
            bContainer.hidden = true
            callLogViewController?.scrollsToTopEnable(true)
            contactViewController?.scrollsToTopEnable(false)
            navigationItem.leftBarButtonItem?.image = R.image.delete_all()
            break
        case 1:
            aContainer.hidden = true
            bContainer.hidden = false
            callLogViewController?.scrollsToTopEnable(false)
            contactViewController?.scrollsToTopEnable(true)
            navigationItem.leftBarButtonItem?.image = R.image.backup()
            break
        default:
            break
        }
    }
    
    @IBAction func leftMenu(sender: UIBarButtonItem) {
        if navigationItem.leftBarButtonItem?.image == R.image.delete_all() {
            let callLogs = App.realm.objects(CallLog.self)
            if callLogs.count != 0 {
                let alertController = UIAlertController(title: "清空通话记录", message: "此操作不可撤回，确认清除所有的通话记录吗？", preferredStyle: .ActionSheet)
                alertController.addAction(UIAlertAction(title: "确认", style: .Destructive) { action in
                    SwiftEventBus.post("deleteAllCallLogs")
                    SwiftEventBus.post("showCallCon")
                    })
                alertController.addAction(UIAlertAction(title: "取消", style: .Cancel) { action in
                    SwiftEventBus.post("showCallCon")
                    })
                presentViewController(alertController, animated: true, completion: nil)
            }
        } else {
            navigationController?.pushViewController(R.storyboard.main.backupViewController()!, animated: true)
        }
    }
    
    @IBAction func scanQRCode(sender: UIBarButtonItem) {
        let qrCodeViewController = QRCodeViewController()
        navigationController?.pushViewController(qrCodeViewController, animated: true)
    }
    
    @IBAction func toUserCenter(sender: UIBarButtonItem) {
        
    }
    
    func statusDidChange() {
        switch App.userAgentAccount.status {
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
    
    func account(account: GSAccount!, didReceiveIncomingCall call: GSCall!) {
//        print("didReceiveIncomingCall")
//        
//        let incomingVideoViewController = R.storyboard.main.incomingVideoViewController()
//        incomingVideoViewController!.inCall = call
//        presentViewController(incomingVideoViewController!, animated: true, completion: nil)
    }
    
    func didReceiveIncomingCall(callData: [NSObject : AnyObject]!) {
        let account = callData["account"] as! GSAccount
        let inCall = callData["inCall"] as! GSCall
        let vid_cnt = callData["vid_cnt"] as! Int
        if vid_cnt == 0 {
            let incomingCallViewController = R.storyboard.main.incomingCallViewController()
            incomingCallViewController?.inCall = inCall
            presentViewController(incomingCallViewController!, animated: true, completion: nil)
        } else {
            let incomingVideoViewController = R.storyboard.main.incomingVideoViewController()
            incomingVideoViewController!.inCall = inCall
            presentViewController(incomingVideoViewController!, animated: true, completion: nil)
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "status" {
            statusDidChange()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier =  segue.identifier {
            switch identifier {
            case R.segue.rootViewController.callLogViewController.identifier:
                callLogViewController = segue.destinationViewController as? CallLogViewController
                break
            case R.segue.rootViewController.contactViewController.identifier:
                contactViewController = segue.destinationViewController as? ContactViewController
                break
            default:
                break
            }
        }
        
    }
}

