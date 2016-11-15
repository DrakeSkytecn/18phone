//
//  EditContactViewController.swift
//  18phone
//
//  Created by 戴全艺 on 2016/10/18.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class EditContactViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var age = -1
    
    var titles = ["性别", "年龄", "地区"]
    
    let sexChoices = ["男", "女"]
    
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! EditContactCell
        switch indexPath.row {
            
        case 0:
            ActionSheetStringPicker.show(withTitle: "", rows: sexChoices, initialSelection: 0, doneBlock: { picker, selectedIndex, selectedValue in
                cell.contentLabel.text = self.sexChoices[selectedIndex]
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
            
            break
        default:
            break
        }
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        
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
