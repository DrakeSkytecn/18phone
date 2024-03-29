//
//  ChangePhoneNumberViewController.swift
//  18phone
//
//  Created by 戴全艺 on 2016/10/18.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit

class ChangePhoneNumberViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    var titles = ["请输入登录密码", "请输入新手机号", "请输入验证码"]
    
    var password = ""
    
    var phoneNumber = ""
    
    var verifyCode = ""
    
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
        if indexPath.row != 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.register_cell_a)!
            cell.titleLabel.text = titles[indexPath.row]
            cell.contentField.delegate = self
            cell.contentField.tag = indexPath.row
            if indexPath.row == 0 {
                cell.contentField.keyboardType = .default
                cell.contentField.isSecureTextEntry = true
                cell.contentField.becomeFirstResponder()
            } else {
                cell.contentField.keyboardType = .numberPad
                ViewUtil.setupNumberBar(cell.contentField)
            }
            cell.contentField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.register_cell_b)!
            cell.titleLabel.text = titles[indexPath.row]
            cell.contentField.delegate = self
            cell.contentField.tag = indexPath.row
            cell.contentField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            cell.idCodeBtn.addTarget(self, action: #selector(codeBtnVerification(_:)), for: .touchUpInside)
            ViewUtil.setupNumberBar(cell.contentField)
            
            return cell
        }
    }
    
    func codeBtnVerification(_ sender: VerifyCodeButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "好的", style: .default, handler: nil)
        alertController.addAction(okAction)
        if phoneNumber.isEmpty {
            alertController.message = "请输入手机号"
            present(alertController, animated: true, completion: nil)
        } else if PhoneUtil.isMobileNumber(phoneNumber) {
            sender.timeFailBeginFrom(60)
            APIUtil.getVerifyCodeInfo(phoneNumber, callBack: nil)
        } else {
            alertController.message = "手机号格式不正确"
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            password = textField.text!
            break
        case 1:
            phoneNumber = textField.text!
            break
        case 2:
            verifyCode = textField.text!
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
        if password.isEmpty {
            alertController.message = "请输入登录密码"
            present(alertController, animated: true, completion: nil)
            return
        }
        if phoneNumber.isEmpty {
            alertController.message = "请输入手机号"
            present(alertController, animated: true, completion: nil)
            return
        }
        if verifyCode.isEmpty {
            alertController.message = "请输入验证码"
            present(alertController, animated: true, completion: nil)
            return
        }
        
        APIUtil.changePhoneNumber(UserDefaults.standard.string(forKey: "userID")!, phoneNumber: phoneNumber, password: password, verificationCode: verifyCode, callBack: { resetPassword in
            if resetPassword.codeStatus == 1 {
                SwiftEventBus.post("reloadUserInfo", sender: self.phoneNumber as NSString)
                _ = self.navigationController?.popViewController(animated: true)
                alertController.message = resetPassword.codeInfo
                self.present(alertController, animated: true, completion: nil)
            } else {
                alertController.message = resetPassword.codeInfo
                self.present(alertController, animated: true, completion: nil)
            }
        })
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
