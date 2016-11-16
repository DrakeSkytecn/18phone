//
//  User.swift
//  18phone
//
//  Created by 陈秋杰 on 2016/10/31.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit
import JSONJoy

struct UserInfo: JSONJoy {
    
    let userData: UserData?
    let codeStatus: Int?
    let codeInfo: String?
    
    init(_ decoder: JSONDecoder) {
        userData = UserData(decoder["data"])
        codeStatus = decoder["codeStatus"].integer
        codeInfo = decoder["codeInfo"].string
    }
}

struct EditUser: JSONJoy {
    
    let codeStatus: Int?
    let codeInfo: String?
    
    init(_ decoder: JSONDecoder) {
        codeStatus = decoder["codeStatus"].integer
        codeInfo = decoder["codeInfo"].string
    }
}

struct UserData {
    
    let userID: String?
    let addressDetail: String?
    let headImageUrl: String?
    let sex: Int?
    let provinceCity: String?
    let name: String?
    let mobile: String?
    let age: Int?
    let personalSignature: String?
    
    init(_ decoder: JSONDecoder) {
        userID = decoder["UserID"].string
        addressDetail = decoder["AddressDetail"].string
        headImageUrl = decoder["HeadImageUrl"].string
        sex = decoder["Sex"].integer
        provinceCity = decoder["ProvinceCity"].string
        name = decoder["Name"].string
        mobile = decoder["Mobile"].string
        age = decoder["Age"].integer
        personalSignature = decoder["PersonalSignature"].string
    }
}

struct DayLeft: JSONJoy {
    
    let day: Int?
    let codeStatus: Int?
    let codeInfo: String?
    
    init(_ decoder: JSONDecoder) {
        day = decoder["day"].integer
        codeStatus = decoder["codeStatus"].integer
        codeInfo = decoder["codeInfo"].string
    }
}
