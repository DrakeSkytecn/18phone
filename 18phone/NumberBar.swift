//
//  NumberBar.swift
//  18phone
//
//  Created by 戴全艺 on 16/10/9.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit

public class NumberBar: UIToolbar {
    
    weak var textField:UITextField?
    
    @IBAction func finish(sender: UIBarButtonItem) {
        textField?.resignFirstResponder()
    }
}
