//
//  Login.swift
//  18phone
//
//  Created by 陈秋杰 on 2016/10/31.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit
import JSONJoy

class LoginInfo: JSONJoy {
    
    let userID: String?
    let codeStatus: Int?
    let codeInfo: String?
    
    required init(_ decoder: JSONDecoder) {
        userID = decoder["userID"].string
        codeStatus = decoder["codeStatus"].integer
        codeInfo = decoder["codeInfo"].string
    }
}
