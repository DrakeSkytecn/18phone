//
//  Register.swift
//  18phone
//
//  Created by 陈秋杰 on 2016/10/28.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit

struct RegisterInfo: JSONJoy {
    
    let userID: String?
    let codeStatus: Int?
    let codeinfo: String?
    
    init(_ decoder: JSONDecoder) {
        userID = decoder["userID"].string
        codeStatus = decoder["codeStatus"].integer
        codeinfo = decoder["codeInfo"].string
    }
}
