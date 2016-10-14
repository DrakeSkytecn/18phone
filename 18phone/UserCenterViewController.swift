//
//  UserCenterViewController.swift
//  18phone
//
//  Created by 戴全艺 on 16/9/23.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit

class UserCenterViewController: UITableViewController {

    var settings: [Int : Any] = [0: [0: [""], 1: [""]],
                    1: [0: [R.image.wallet()!, R.image.bill()!],
                        1: ["我的钱包", "我的账单"]],
                    2: [0: [R.image.setting()!, R.image.about()!],
                        1: ["我的设置", "关于18phone"]]]
    
    var icons1 = [R.image.wallet(), R.image.bill()]
    var icons2 = [R.image.setting(), R.image.about()]
    var titles1 = ["我的钱包", "我的账单"]
    var titles2 = ["我的设置", "关于18phone"]
    
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 2
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.user_detail_cell)
            return cell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.setting_cell)
            if indexPath.section == 1 {
                cell?.imageView?.image = icons1[indexPath.row]
                cell?.textLabel?.text = titles1[indexPath.row]
            } else if indexPath.section == 2 {
                cell?.imageView?.image = icons2[indexPath.row]
                cell?.textLabel?.text = titles2[indexPath.row]
            }
            
            return cell!
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath as NSIndexPath).section == 0 {
            return 100.0
        } else {
            return 60.0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
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
