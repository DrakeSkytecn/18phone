//
//  UserCenterViewController.swift
//  18phone
//
//  Created by 戴全艺 on 16/9/23.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit
import SwiftEventBus

class UserCenterViewController: UITableViewController {
    
    var icons1 = [R.image.wallet(), R.image.bill()]
    
    var icons2 = [R.image.setting(), R.image.about()]
    
    var titles1 = ["我的钱包", "我的账单"]
    
    var titles2 = ["我的设置", "关于18phone"]
    
    var userData: UserData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SwiftEventBus.onMainThread(self, name: "reloadUserInfo") { result in
//            let phoneNumber = result.object as! String
            self.reloadUserInfo("")
        }
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
            if let userID = UserDefaults.standard.string(forKey: "userID") {
                APIUtil.getUserInfo(userID, callBack: { userInfo in
                    self.userData = userInfo.userData
                    if self.userData!.headImageUrl != nil {
                        cell?.headPhoto.piQ_imageFromUrl(self.userData!.headImageUrl!, placeholderImage: R.image.head_photo_default()!)
                    } else {
                        cell?.headPhoto.image = R.image.head_photo_default()
                    }
                    if self.userData?.name == nil || self.userData!.name!.isEmpty {
                        cell?.nameLabel.text = self.userData?.mobile
                    } else {
                        cell?.nameLabel.text = self.userData?.name
                    }
                    if self.userData?.sex == Sex.male.rawValue {
                        cell?.sexImage.image = R.image.male()
                    } else if self.userData?.sex == Sex.female.rawValue {
                        cell?.sexImage.image = R.image.female()
                    }
                    if self.userData!.age != nil && self.userData!.age != -1  {
                        cell?.ageLabel.text = String(describing: self.userData!.age!) + "岁"
                    }
                    cell?.areaLabel.text = self.userData!.provinceCity
                    cell?.signLabel.text = self.userData!.personalSignature
                })
            }
            
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
        switch indexPath.section {
        case 0:
            break
        case 1:
            if indexPath.row == 0 {
                
            } else {
                performSegue(withIdentifier: R.segue.userCenterViewController.billViewController, sender: nil)
            }
            break
        case 2:
            if indexPath.row == 0 {
                performSegue(withIdentifier: R.segue.userCenterViewController.mySettingViewController, sender: nil)
            } else {
                performSegue(withIdentifier: R.segue.userCenterViewController.aboutViewController, sender: nil)
            }
            break
        default:
            break
        }
    }
    
    func resetUserPhone(_ phoneNumber: String) {
        
    }
    
    func reloadUserInfo(_ phoneNumber: String) {
//        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! UserDetailCell
//        cell.nameLabel.text = phoneNumber
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.segue.userCenterViewController.editUserViewController.identifier {
            let editUserViewController = segue.destination as! EditUserViewController
            if let userID = UserDefaults.standard.string(forKey: "userID") {
                editUserViewController.userID = userID
                editUserViewController.userData = userData
            }
        }
    }
}
