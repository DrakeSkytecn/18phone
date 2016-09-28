//
//  LoginViewController.swift
//  18phone
//
//  Created by 戴全艺 on 16/9/27.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    var titles = ["请输入手机号", "请输入密码"]
    
    var phoneNumber = ""
    
    var password = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        navigationItem.backBarButtonItem = nil
    }
    
    override func viewWillAppear(animated: Bool) {
        //navigationController?.navigationBar.hidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.login_cell)
        cell?.titleLabel.text = titles[indexPath.row]
        cell?.contentField.tag = indexPath.row
        cell?.contentField.delegate = self
        cell?.contentField.addTarget(self, action: #selector(textFieldDidChange(_:)), forControlEvents: .EditingChanged)
        if indexPath.row == 0 {
            cell?.contentField.text = "18823754172"
            phoneNumber = "18823754172"
            cell?.contentField.keyboardType = .NumberPad
            cell?.contentField.becomeFirstResponder()
        } else {
            cell?.contentField.text = "123"
            password = "123"
            cell?.contentField.keyboardType = .Default
        }

        return cell!
    }
    
    func textFieldDidChange(textField: UITextField) {
        switch textField.tag {
        case 0:
            phoneNumber = textField.text!
            break
        case 1:
            password = textField.text!
            break
        default:
            break
        }
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func login(sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "好的", style: .Default, handler: nil)
        alertController.addAction(okAction)
        if phoneNumber.isEmpty {
            alertController.message = "请输入手机号"
            presentViewController(alertController, animated: true, completion: nil)
            return
        }
        if !PhoneUtil.isMobileNumber(phoneNumber) {
            alertController.message = "输入的手机号格式不正确"
            presentViewController(alertController, animated: true, completion: nil)
            return
        }
        if password.isEmpty {
            alertController.message = "请输入密码"
            presentViewController(alertController, animated: true, completion: nil)
            return
        }
        presentViewController(R.storyboard.main.kTabBarController()!, animated: true, completion: nil)
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
