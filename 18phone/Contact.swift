//
//  Contact.swift
//  18phone
//
//  Created by 戴全艺 on 16/8/22.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import Foundation
import RealmSwift

class Phone: Object {
    dynamic var number = ""
}

/**
 性别
 
 - Male:    男
 - Female:  女
 - Unknown: 未编辑
 */
enum Sex: Int {
    case Male
    case Female
    case Unknown
}

/// 联系人数据对象
struct LocalContactInfo {
    
    /// 联系人ID
    var identifier: String?
    
    /// 联系人头像
    var headPhoto: NSData?
    
    /// 联系人姓名
    var name: String?
    
    /// 联系人电话
    var phones: List<Phone>?
    
    init () {
        identifier = nil
        headPhoto = nil
        name = nil
        phones = List<Phone>()
    }
}

class AppContactInfo: Object {
    
    /// 联系人ID
    dynamic var identifier = ""
    
    /// 注册后分配的账号
    var account = 0
    
    /// 该联系人是否是18phone的用户标识
    var isRegister = false
    
    /// 联系人性别
    dynamic var sex = Sex.Unknown.rawValue
    
    /// 联系人年龄
    dynamic var age = -1
    
    /// 联系人地区
    dynamic var area = ""
}



