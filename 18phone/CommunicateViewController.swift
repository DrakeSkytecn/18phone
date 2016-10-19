//
//  CommunicateViewController.swift
//  18phone
//
//  Created by 戴全艺 on 2016/10/19.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit

class CommunicateViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initPageMenu()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initPageMenu() {
        let date = Date()
        var controllerArray = [UIViewController]()
        for i in (1...date.month).reversed() {
            let communicateListViewController = R.storyboard.main.communicateListViewController()!
            communicateListViewController.title = "\(i)月"
            controllerArray.append(communicateListViewController)
        }
        let communicateListViewController1 = R.storyboard.main.communicateListViewController()!
        communicateListViewController1.title = "\(date.year - 1)年12月"
        let communicateListViewController2 = R.storyboard.main.communicateListViewController()!
        communicateListViewController2.title = "\(date.year - 1)年11月"
        controllerArray.append(communicateListViewController1)
        controllerArray.append(communicateListViewController2)
        
        let parameters: [CAPSPageMenuOption] = [
            .scrollMenuBackgroundColor(UIColor.white),
            .viewBackgroundColor(UIColor.white),
            .selectionIndicatorColor(UIColor(red: 38.0/255.0, green: 173.0/255.0, blue: 86.0/255.0, alpha: 1.0)),
            .selectedMenuItemLabelColor(UIColor(red: 38.0/255.0, green: 173.0/255.0, blue: 86.0/255.0, alpha: 1.0)),
            .unselectedMenuItemLabelColor(UIColor.black),
            .bottomMenuHairlineColor(UIColor(red: 70.0/255.0, green: 70.0/255.0, blue: 80.0/255.0, alpha: 1.0)),
            .centerMenuItems(true),
            .menuMargin(0.0),
            .menuItemWidth(100.0),
            .menuHeight(64.0)
        ]
        let pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0, y: 0, width: Screen.width, height: view.frame.height), pageMenuOptions: parameters)
        addChildViewController(pageMenu)
        view.addSubview(pageMenu.view)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
