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
    let ClientNumber: String?
    let ClientPwd: String?
    let codeStatus: Int?
    let codeInfo: String?
    
    init(_ decoder: JSONDecoder) {
        userID = decoder["userID"].string
        ClientNumber = decoder["ClientNumber"].string
        ClientPwd = decoder["ClientPwd"].string
        codeStatus = decoder["codeStatus"].integer
        codeInfo = decoder["codeInfo"].string
    }
}
