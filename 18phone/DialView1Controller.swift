//
//  DialView1Controller.swift
//  18phone
//
//  Created by Kratos on 8/13/16.
//  Copyright © 2016 Kratos. All rights reserved.
//

import UIKit

class DialView1Controller: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    /// 拨号盘数字按键上的字母
    let characters = ["ABC", "DEF", "GHI", "JKL", "MNO", "PQRS", "TUV", "WXYZ"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        /// 数字按键要展示的布局
        case 0...8:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(R.reuseIdentifier.dial_1.identifier, forIndexPath: indexPath) as! DialNumberCell
            
            if indexPath.row == 0 {
                cell.number.text = "\(indexPath.row + 1)"
            } else {
                cell.number.text = "\(indexPath.row + 1)"
                cell.character.text = characters[indexPath.row - 1]
            }
            return cell
        case 10:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(R.reuseIdentifier.dial_3.identifier, forIndexPath: indexPath) as! DialNumberCell
            cell.number.text = "0"
            return cell
        /// 粘贴和删除按键要展示的布局
        case 9, 11:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(R.reuseIdentifier.dial_2.identifier, forIndexPath: indexPath) as! DialIconCell
            if indexPath.row == 9 {
                cell.icon.image = R.image.paste()
            }else{
                cell.icon.image = R.image.delete()
            }
            
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.cellForItemAtIndexPath(indexPath)?.backgroundColor = UIColor.groupTableViewBackgroundColor()
    }
    
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.cellForItemAtIndexPath(indexPath)?.backgroundColor = UIColor.clearColor()
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
