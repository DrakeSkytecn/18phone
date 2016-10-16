//
//  ViewController.swift
//  18phone
//
//  Created by Kratos on 2016/10/15.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var conHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let controllerArray : [UIViewController] = [R.storyboard.main.a()! , R.storyboard.main.b()!]
        let parameters: [CAPSPageMenuOption] = [
            .scrollMenuBackgroundColor(UIColor.white),
            .viewBackgroundColor(UIColor.white),
            .selectionIndicatorColor(UIColor(red: 38.0/255.0, green: 173.0/255.0, blue: 86.0/255.0, alpha: 1.0)),
            .selectedMenuItemLabelColor(UIColor(red: 38.0/255.0, green: 173.0/255.0, blue: 86.0/255.0, alpha: 1.0)),
            .unselectedMenuItemLabelColor(UIColor.black),
            .bottomMenuHairlineColor(UIColor(red: 70.0/255.0, green: 70.0/255.0, blue: 80.0/255.0, alpha: 1.0)),
            .centerMenuItems(true),
            .menuItemWidth(Screen.width / 2),
            .menuMargin(0.0)
        ]
        print("\(conHeight.constant)")
        print("\(Screen.width)")
        print("\(view.frame.height)")
        let pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0, y: conHeight.constant, width: Screen.width, height: view.frame.height - conHeight.constant), pageMenuOptions: parameters)
        addChildViewController(pageMenu)
        view.addSubview(pageMenu.view)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
