//
//  ChangePasswordViewController.swift
//  18phone
//
//  Created by 戴全艺 on 2016/10/18.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    var titles = ["请输入原登录密码", "请输入新登录密码", "请输入确认新登录密码"]
    
    var oldPassword = ""
    
    var newPassword = ""
    
    var newPasswordConfirm = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.login_cell)!
        cell.titleLabel.text = titles[indexPath.row]
        cell.contentField.delegate = self
        cell.contentField.tag = indexPath.row
        cell.contentField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        if indexPath.row == 0 {
            cell.contentField.becomeFirstResponder()
        }
        
        return cell
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            oldPassword = textField.text!
            break
        case 1:
            newPassword = textField.text!
            break
        case 2:
            newPasswordConfirm = textField.text!
            break
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func submit(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "好的", style: .default, handler: nil)
        alertController.addAction(okAction)
        if oldPassword.isEmpty {
            alertController.message = "请输入原登录密码"
            present(alertController, animated: true, completion: nil)
            return
        }
        if newPassword.isEmpty {
            alertController.message = "请输入新登录密码"
            present(alertController, animated: true, completion: nil)
            return
        }
        if newPasswordConfirm.isEmpty {
            alertController.message = "请再次输入新登录密码"
            present(alertController, animated: true, completion: nil)
            return
        }
        if newPassword != newPasswordConfirm {
            alertController.message = "两次输入的密码不匹配"
            present(alertController, animated: true, completion: nil)
            return
        }
        if oldPassword == newPassword {
            alertController.message = "新密码不能和原密码相同"
            present(alertController, animated: true, completion: nil)
            return
        }
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
