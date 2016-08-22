//
//  Contact.swift
//  18phone
//
//  Created by 戴全艺 on 16/8/22.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import Foundation
import RealmSwift

class Contact: Object {
    dynamic var account = 0
    dynamic var phone = ""
    dynamic var hasAccount = false
}

struct ContactDetail {
    
    var headPhoto: String?
    var name: String?
    var sex: Bool?
    var age: Int?
    var phone: String?
    var area: String?
}

