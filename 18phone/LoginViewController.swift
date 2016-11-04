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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //navigationController?.navigationBar.hidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.login_cell)!
        cell.titleLabel.text = titles[indexPath.row]
        cell.contentField.tag = indexPath.row
        cell.contentField.delegate = self
        cell.contentField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        if (indexPath as NSIndexPath).row == 0 {
            cell.contentField.text = "18823754172"
            phoneNumber = "18823754172"
            cell.contentField.keyboardType = .numberPad
            cell.contentField.becomeFirstResponder()
        } else {
            cell.contentField.text = "123"
            password = "123"
            cell.contentField.keyboardType = .default
        }

        return cell
    }
    
    func textFieldDidChange(_ textField: UITextField) {
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func login(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "好的", style: .default, handler: nil)
        alertController.addAction(okAction)
        if phoneNumber.isEmpty {
            alertController.message = "请输入手机号"
            present(alertController, animated: true, completion: nil)
            return
        }
        if !PhoneUtil.isMobileNumber(phoneNumber) {
            alertController.message = "输入的手机号格式不正确"
            present(alertController, animated: true, completion: nil)
            return
        }
        if password.isEmpty {
            alertController.message = "请输入密码"
            present(alertController, animated: true, completion: nil)
            return
        }
        APIUtil.login(phoneNumber, password: password, callBack: { loginInfo in
            if loginInfo.codeStatus == 1 {
                let userDefaults = UserDefaults.standard
                if userDefaults.string(forKey: "userID") == nil{
                    userDefaults.set(loginInfo.userID, forKey: "userID")
                    userDefaults.synchronize()
                }
                App.autoLogin(self.phoneNumber, password: self.password)
                self.present(R.storyboard.main.kTabBarController()!, animated: true, completion: nil)
            } else {
                alertController.message = loginInfo.codeInfo
                self.present(alertController, animated: true, completion: nil)
            }
        })
    }
}
