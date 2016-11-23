//
//  EditContactViewController.swift
//  18phone
//
//  Created by 戴全艺 on 2016/10/18.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import SwiftEventBus
import ContactsUI

class EditContactViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CNContactViewControllerDelegate {

    var age = -1
    
    var sex = Sex.unknown.rawValue
    
    var area = ""
    
    var titles = ["性别", "年龄", "地区"]
    
    let sexChoices = ["男", "女"]
    
    var appContactInfo: AppContactInfo?
    
    var contact: CNContact?
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.edit_contact_cell)!
        cell.titleLabel.text = titles[indexPath.row]
        switch indexPath.row {
        case 0:
            sex = appContactInfo!.sex
            if appContactInfo!.sex != Sex.unknown.rawValue {
                cell.contentLabel.text = sexChoices[appContactInfo!.sex - 1]
            }
            break
        case 1:
            age = appContactInfo!.age
            if appContactInfo!.age != -1 {
                cell.contentLabel.text = "\(appContactInfo!.age)岁"
            }
            break
        case 2:
            area = appContactInfo!.area
            cell.contentLabel.text = area
            break
        default:
            break
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! EditContactCell
        switch indexPath.row {
            
        case 0:
            ActionSheetStringPicker.show(withTitle: "", rows: sexChoices, initialSelection: 0, doneBlock: { picker, selectedIndex, selectedValue in
                cell.contentLabel.text = self.sexChoices[selectedIndex]
                self.sex = selectedIndex + 1
                }, cancel: { _ in
                    
                }, origin: cell)
            break
        case 1:
            ActionSheetDatePicker.show(withTitle: "生日", datePickerMode: .date, selectedDate: Date(), doneBlock: { picker, selectedValue, selectedIndex in
                let birthday = selectedValue as! Date
                self.age = DateUtil.getAgeFromBirthday((birthday))
                cell.contentLabel.text = "\(self.age)岁"
                }, cancel: { _ in
                    
                }, origin: cell)
            break
        case 2:
            let areaPicker = SelectView(zgqFrame: Screen.bounds, selectCityTtitle: "地区")
            areaPicker?.showCityView({ province, city, district in
                let provinceStr = province![province!.startIndex..<province!.index(province!.endIndex, offsetBy: -1)]
                let cityStr = city![city!.startIndex..<city!.index(city!.endIndex, offsetBy: -1)]
                switch provinceStr {
                case "北京", "上海", "天津", "重庆":
                    self.area = provinceStr
                    cell.contentLabel.text = provinceStr
                    break
                default:
                    self.area = provinceStr + cityStr
                    cell.contentLabel.text = self.area
                    break
                }
            })
            break
        default:
            break
        }
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        var userInfo = [String:Any]()
        try! App.realm.write {
            appContactInfo?.age = age
            appContactInfo?.sex = sex
            appContactInfo?.area = area
        }
        SwiftEventBus.post("reloadContactInfo")
        _ = navigationController?.popViewController(animated: true)
    }

    @IBAction func editLocal(_ sender: UIButton) {
//        let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactIdentifierKey, CNContactImageDataKey, CNContactThumbnailImageDataKey, CNContactImageDataAvailableKey, CNContactPhoneNumbersKey, CNContactPhoneticGivenNameKey, CNContactPhoneticFamilyNameKey, CNContactViewController.descriptorForRequiredKeys()] as [Any]
        let contactViewController = CNContactViewController(forNewContact: contact)
        contactViewController.title = "编辑联系人"
        contactViewController.delegate = self
//        contactViewController.allowsEditing = true
//        contactViewController.allowsActions = true
//        contactViewController.displayedPropertyKeys = keysToFetch
        navigationController?.pushViewController(contactViewController, animated: true)
    }
    
//    func contactViewController(_ viewController: CNContactViewController, shouldPerformDefaultActionFor property: CNContactProperty) -> Bool {
//        print("shouldPerformDefaultActionFor")
//        return false
//    }
    
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        print("didCompleteWith")
        _ = navigationController?.popViewController(animated: true)
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
