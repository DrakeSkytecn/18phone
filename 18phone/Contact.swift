//
//  Contact.swift
//  18phone
//
//  Created by 戴全艺 on 16/8/22.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import Foundation
import RealmSwift
import JSONJoy

class Phone {
    var number = ""
}

/// 用于收集和存放号码归属地
class Area: Object {
    
    /// 号码作为键
    dynamic var key = ""
    
    /// 号码归属地
    dynamic var name = ""
}

/**
 性别
 
 - Unknown: 未编辑
 - Male:    男
 - Female:  女
 */
enum Sex: Int {
    case unknown
    case male
    case female
}

/// 联系人数据对象
struct LocalContactInfo {
    
    /// 联系人ID
    var identifier: String?
    
    /// 联系人头像
    var headPhoto: Data?
    
    /// 联系人姓名
    var name: String?
    
    /// 联系人电话
    var phones: Array<Phone>?
    
    /// 是否为18phone注册用户的标识
    var isRegister = false
    
    init () {
        identifier = nil
        headPhoto = nil
        name = nil
        phones = Array<Phone>()
    }
}

class AppContactInfo: Object {
    
    /// 联系人ID
    dynamic var identifier = ""
    
    /// 注册后分配的账号ID
    dynamic var accountId = ""
    
    /// 该联系人是否是18phone的用户标识
    dynamic var isRegister = false
    
    /// 联系人性别
    dynamic var sex = Sex.unknown.rawValue
    
    /// 联系人年龄
    dynamic var age = -1
    
    /// 联系人地区
    dynamic var area = ""
    
    /// 联系人个性签名
    dynamic var signature = ""
}

struct ContactIDInfo: JSONJoy {
    
    let userID: String?
    let isRegister: Bool?
    let codeStatus: Int?
    let codeinfo: String?
    
    init(_ decoder: JSONDecoder) {
        userID = decoder["UserID"].string
        isRegister = decoder["IsRegister"].bool
        codeStatus = decoder["codeStatus"].integer
        codeinfo = decoder["codeInfo"].string
    }
}

struct BackupContactInfo: JSONJoy {
    
    let endTime: String?
    let upsucceedCount: Int?
    let upFailCount: Int?
    let codeStatus: Int?
    let codeinfo: String?
    
    init(_ decoder: JSONDecoder) {
        endTime = decoder["endTime"].string
        upsucceedCount = decoder["upsucceedCount"].integer
        upFailCount = decoder["upFailCount"].integer
        codeStatus = decoder["codeStatus"].integer
        codeinfo = decoder["codeInfo"].string
    }
}

struct ContactInfo: JSONJoy {
    
    let PhoneID: String?
    let Name: String?
    let Mobile: String?
    let Sex: Int?
    let Age: Int?
    let Area: String?
    let PersonalSignature: String?
    let HeadImageUrl: String?
    let BUserID: String?
    
    init(_ decoder: JSONDecoder) {
        PhoneID = decoder["PhoneID"].string
        Name = decoder["Name"].string
        Mobile = decoder["Mobile"].string
        Sex = decoder["Sex"].integer
        Age = decoder["Age"].integer
        Area = decoder["Area"].string
        PersonalSignature = decoder["PersonalSignature"].string
        HeadImageUrl = decoder["HeadImageUrl"].string
        BUserID = decoder["BUserID"].string
    }
}

struct DownloadContactInfos: JSONJoy {
    
    let codeStatus: Int?
    let codeInfo: String?
    var contactInfos = [ContactInfo]()
    
    init(_ decoder: JSONDecoder) {
        codeStatus = decoder["codeStatus"].integer
        codeInfo = decoder["codeInfo"].string
        if let tempContactInfos = decoder["data"].array {
            for contactInfoDecoder in tempContactInfos {
                contactInfos.append(ContactInfo(contactInfoDecoder))
            }
        }
    }
}
