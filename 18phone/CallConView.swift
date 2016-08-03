//
//  CallConView.swift
//  18phone
//
//  Created by 戴全艺 on 16/8/3.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit

class CallConView: UIView {
    
    var delegate: DialViewController?
    
    @IBAction func call(sender: UIButton) {
        if delegate != nil {
            delegate?.call(sender)
        }
    }

}
