//
//  VerifyCode.swift
//  18phone
//
//  Created by 陈秋杰 on 2016/10/28.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit

struct VerifyCodeInfo: JSONJoy {

    let codeStatus: Int?
    let codeInfo: String?
    
    init(_ decoder: JSONDecoder) {
        codeStatus = decoder["codeStatus"].integer
        codeInfo = decoder["codeInfo"].string
    }
}
