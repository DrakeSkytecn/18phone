//
//  NumberBar.swift
//  18phone
//
//  Created by 戴全艺 on 16/10/9.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit

open class NumberBar: UIToolbar {
    
    weak var textField:UITextField?
    
    @IBAction func finish(_ sender: UIBarButtonItem) {
        textField?.resignFirstResponder()
    }
}
