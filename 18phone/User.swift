//
//  User.swift
//  18phone
//
//  Created by 陈秋杰 on 2016/10/31.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit
import JSONJoy

class UserInfo: JSONJoy {
    
    let codeStatus: Int?
    let codeInfo: String?
    
    required init(_ decoder: JSONDecoder) {
        codeStatus = decoder["codeStatus"].integer
        codeInfo = decoder["codeInfo"].string
    }
}

class DayLeft: JSONJoy {
    
    let day: Int?
    let codeStatus: Int?
    let codeInfo: String?
    
    required init(_ decoder: JSONDecoder) {
        day = decoder["Data"].integer
        codeStatus = decoder["codeStatus"].integer
        codeInfo = decoder["codeInfo"].string
    }
}
