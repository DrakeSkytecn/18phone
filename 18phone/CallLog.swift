//
//  CallLog.swift
//  bottompopmenu
//
//  Created by 戴全艺 on 16/7/27.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import Foundation
import RealmSwift

/**
 通话记录类型
 
 - InUnConnected:  拨入未接通
 - InConnected:    拨入已接通
 - OutUnConnected: 拨出未接通
 - OutConnected:   拨出已接通
 */
enum CallState: Int {
    
    /// 拨入未接通
    case InUnConnected
    
    /// 拨入已接通
    case InConnected
    
    /// 拨出未接通
    case OutUnConnected
    
    /// 拨出已接通
    case OutConnected
}

/// 通话记录数据对象
class CallLog: Object {
    
    /// 联系人头像
    dynamic var headPhoto = ""
    
    /// 联系人姓名
    dynamic var name = ""
    
    /// 手机号
    dynamic var phone = ""
    
    /// 通话记录类型
    dynamic var callState = CallState.InUnConnected.rawValue
    
    /// 通话方式
    dynamic var callType = 0
    
    /// 号码归属地
    dynamic var area = ""
    
    /// 通话开始时间
    dynamic var callStartTime = NSDate()
    
    /// 通话时长
    dynamic var callDuration = NSDate()
}

struct RetData: JSONJoy {
    
    let phone: String?
    let supplier: String?
    let province: String?
    let city: String?
    
    init(_ decoder: JSONDecoder) {
        phone = decoder["phone"].string
        supplier = decoder["supplier"].string
        province = decoder["province"].string
        city = decoder["city"].string
    }
}

struct PhoneAreaInfo: JSONJoy {
    
    let errNum: Int?
    let retMsg: String?
    let retData: RetData?
    
    init(_ decoder: JSONDecoder) {
        errNum = decoder["errNum"].integer
        retMsg = decoder["retMsg"].string
        retData = RetData(decoder["retData"])
    }
}
