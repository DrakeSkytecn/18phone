//
//  UserCenterViewController.swift
//  18phone
//
//  Created by 戴全艺 on 16/9/23.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit

class UserCenterViewController: UITableViewController {

    var settings = [0: [0: [""],
                        1: [""]],
                    1: [0: [R.image.wallet()!, R.image.bill()!],
                        1: ["我的钱包", "我的账单"]],
                    2: [0: [R.image.setting()!, R.image.about()!],
                        1: ["我的设置", "关于18phone"]]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return settings.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return settings[section]![1]!.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.user_detail_cell)
            return cell!
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.setting_cell)
            cell?.imageView?.image = settings[indexPath.section]![0]![indexPath.row] as? UIImage
            cell?.textLabel?.text = settings[indexPath.section]![1]![indexPath.row] as? String
            
            return cell!
        }
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100.0
        } else {
            return 60.0
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
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
