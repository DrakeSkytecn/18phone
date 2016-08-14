//
//  ViewController.swift
//  bottompopmenu
//
//  Created by Kratos on 7/9/16.
//  Copyright © 2016 Kratos. All rights reserved.
//

import UIKit
import SwiftEventBus

/// 拨号页面根控制器
class RootViewController: UIViewController {

    /// 用于判断拨号盘是否展开
    private var isMenuShow: Bool = false
    
    /// 用于判断拨号页面是否显示
    private var isViewHidden: Bool = true
    
    /// 拨号盘
    @IBOutlet weak var menuView: UIView!
    
    /// 通话子页容器
    @IBOutlet weak var aContainer: UIView!
    
    /// 通讯录子页容器
    @IBOutlet weak var bContainer: UIView!
    
    var dialViewController = R.storyboard.main.dialViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        //navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidAppear(animated: Bool) {
//        if !isMenuShow {
//            resetMenuY(-menuView.frame.height)
//        }
        isViewHidden = false
    }
    
    override func viewDidDisappear(animated: Bool) {
        isViewHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     调用这个方法会根据当前拨号盘的状态来决定展开还是收起拨号盘
     
     - parameter item: 选中的底部子菜单项
     */
    func changeMenuState(item: UITabBarItem) {
        if !isViewHidden {
            if isMenuShow {
                hide()
                item.selectedImage = R.image.dial_up()
                item.title = "展开"
            } else {
                show()
                item.selectedImage = R.image.dial_down()
                item.title = "收起"
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
        var rect = self.menuView.frame
        rect.origin.y = rect.origin.y + height
        self.menuView.frame = rect
        isMenuShow = true
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
            break
        case 1:
            aContainer.hidden = true
            bContainer.hidden = false
            break
        default:
            break
        }
    }
    
    @IBAction func leftMenu(sender: UIBarButtonItem) {
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
            SwiftEventBus.post("hideCallCon")
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
}

