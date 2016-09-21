//
//  DetailMenuViewController.swift
//  18phone
//
//  Created by 戴全艺 on 16/9/21.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit

class DetailMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var phones: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DetailMenuViewController viewDidLoad")
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func videoCall(sender: UIButton) {
        
    }
    
    @IBAction func voiceCall(sender: UIButton) {
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return phones!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.detail_phone_cell)
        let phoneNumber = PhoneUtil.formatPhoneNumber(phones![indexPath.row])
        cell?.textLabel?.text = phoneNumber
        cell?.detailTextLabel?.text = "未知归属地"
        PhoneUtil.getPhoneAreaInfo(phoneNumber) { phoneAreaInfo in
            if phoneAreaInfo.errNum == 0 {
                cell?.detailTextLabel?.text = (phoneAreaInfo.retData?.province!)! + (phoneAreaInfo.retData?.city!)!
            }
        }

        return cell!
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
