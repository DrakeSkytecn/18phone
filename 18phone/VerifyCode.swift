//
//  VerifyCode.swift
//  18phone
//
//  Created by 陈秋杰 on 2016/10/28.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit
import JSONJoy

struct VerifyCodeInfo: JSONJoy {

    let codeStatus: Int?
    let codeinfo: String?
    
    init(_ decoder: JSONDecoder) {
        codeStatus = decoder["codeStatus"].integer
        codeinfo = decoder["codeinfo"].string
    }
}
