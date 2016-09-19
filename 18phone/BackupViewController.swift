//
//  BackupViewController.swift
//  18phone
//
//  Created by 戴全艺 on 16/9/18.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit
import Contacts

class BackupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var contactCount = 0
    
    let titles = ["本地通讯录", "云端通讯录", "同步通讯录", "恢复通讯录", "自动同步"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let store = CNContactStore()
        let keysToFetch = [CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName)]
        let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)
        try! store.enumerateContactsWithFetchRequest(fetchRequest) {(let contact, let stop) -> Void in
            self.contactCount = self.contactCount + 1
        }
        print("count \(contactCount)")
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if indexPath.row != 4 {
            let cell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.backup_cell_a)
            cell!.titleLabel.text = titles[indexPath.row]
            switch indexPath.row {
            case 0:
                cell?.infoLabel.text = "\(contactCount)人"
                break
            case 1:
                cell?.infoLabel.text = "\(contactCount)人"
                break
            case 2:
                cell?.infoLabel.text = "上次同步2016/09/15"
                break
            default:
                break
            }
            
            return cell!
            
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.backup_cell_b)
            cell!.titleLabel.text = titles[indexPath.row]
            return cell!
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
