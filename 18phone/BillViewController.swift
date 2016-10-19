//
//  BillViewController.swift
//  18phone
//
//  Created by 戴全艺 on 2016/10/19.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit

class BillViewController: UIViewController {
    
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
        let controllerArray : [UIViewController] = [R.storyboard.main.consumeViewController()! , R.storyboard.main.communicateViewController()!]
        let parameters: [CAPSPageMenuOption] = [
            .scrollMenuBackgroundColor(UIColor.white),
            .viewBackgroundColor(UIColor.white),
            .selectionIndicatorColor(UIColor(red: 38.0/255.0, green: 173.0/255.0, blue: 86.0/255.0, alpha: 1.0)),
            .selectedMenuItemLabelColor(UIColor(red: 38.0/255.0, green: 173.0/255.0, blue: 86.0/255.0, alpha: 1.0)),
            .unselectedMenuItemLabelColor(UIColor.black),
            .bottomMenuHairlineColor(UIColor(red: 70.0/255.0, green: 70.0/255.0, blue: 80.0/255.0, alpha: 1.0)),
            .centerMenuItems(true),
            .menuItemWidth(Screen.width / 2),
            .menuMargin(0.0),
            .menuHeight(44.0)
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
