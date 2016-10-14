//
//  KTabBarController.swift
//  bottompopmenu
//
//  Created by Kratos on 7/10/16.
//  Copyright © 2016 Kratos. All rights reserved.
//

import UIKit

/// app第一级导航控制器
class KTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //tabBar.tintColor = UIColor(red: 0, green: 128, blue: 0, alpha: 1)
//        for item in tabBar.items! {
//            print("KTabBarController item")
//            item.image?.imageWithRenderingMode(.AlwaysOriginal)
//            item.selectedImage?.imageWithRenderingMode(.AlwaysOriginal)
//        }
        selectedIndex = 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 1:
            (viewControllers![1].childViewControllers[0] as! RootViewController).changeMenuState(item)
        default:
            break
        }
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
