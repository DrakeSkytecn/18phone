//
//  EditUserViewController.swift
//  18phone
//
//  Created by Kratos on 9/25/16.
//  Copyright © 2016 Kratos. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import Async

class EditUserViewController: UITableViewController, UITextFieldDelegate {

    var lastScrollOffset: CGFloat = 0.0
    
    @IBOutlet weak var headPhoto: UIImageView!
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var sexLabel: UILabel!
    
    @IBOutlet weak var ageLabel: UILabel!
    
    @IBOutlet weak var areaLabel: UILabel!
    
    @IBOutlet weak var signField: UITextField!
    
    @IBOutlet weak var addressField: UILabel!
    
    let sexChoices = ["男", "女"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        headPhoto.image = R.image.head_photo_default()
        nameField.delegate = self
        signField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        hideKeyBoard()
        switch indexPath.row {
        case 0:
            Async.main {
                self.headphotoSheet()
            }
            break
        case 2:
            ActionSheetStringPicker.show(withTitle: "", rows: sexChoices, initialSelection: 0, doneBlock: { picker, selectedIndex, selectedValue in
                self.sexLabel.text = self.sexChoices[selectedIndex]
                }, cancel: { _ in
                    
                }, origin: cell)
            break
        case 3:
            ActionSheetDatePicker.show(withTitle: "生日", datePickerMode: .date, selectedDate: Date(), doneBlock: { picker, selectedValue, selectedIndex in
                let birthday = selectedValue as! Date
                self.ageLabel.text = DateUtil.getAgeFromBirthday((birthday)) + "岁"
                }, cancel: { _ in
                
                }, origin: cell)
            break
        default:
            break
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tableView {
            let y = scrollView.contentOffset.y
            if y < lastScrollOffset {
                hideKeyBoard()
            }
            lastScrollOffset = y
        }
    }

    @IBAction func save(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editHeadphoto(_ sender: UITapGestureRecognizer) {
        headphotoSheet()
    }
    
    func headphotoSheet() {
        print("headphotoSheet")
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "拍照", style: .default) { action in
            
            })
        alertController.addAction(UIAlertAction(title: "相册", style: .default) { action in
            
            })
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel) { action in
            
            })
        present(alertController, animated: true, completion: nil)
    }
    
    func hideKeyBoard() {
        if nameField.isFirstResponder {
            nameField.resignFirstResponder()
        }
        if signField.isFirstResponder {
            signField.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
