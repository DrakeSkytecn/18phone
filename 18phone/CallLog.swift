//
//  CallLog.swift
//  bottompopmenu
//
//  Created by 戴全艺 on 16/7/27.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import Foundation
import RealmSwift
import JSONJoy

/**
 通话记录类型
 
 - InUnConnected:  拨入未接通
 - InConnected:    拨入已接通
 - OutUnConnected: 拨出未接通
 - OutConnected:   拨出已接通
 */
enum CallState: Int {
    
    /// 拨入未接通
    case inUnConnected
    
    /// 拨入已接通
    case inConnected
    
    /// 拨出未接通
    case outUnConnected
    
    /// 拨出已接通
    case outConnected
}

enum CallType: Int {
    
    /// 语音通话
    case voice
    
    /// 视频通话
    case video
}

enum DialLine: Int {
    
    /// 互联网语音
    case p2p
    
    /// 直拨通话
    case direct
    
    /// 回拨通话
    case dialBack
}

/// 通话记录数据对象
class CallLog: Object {
    
    /// 通讯录联系人ID
    dynamic var contactId = ""
    
    /// 联系人头像
    dynamic var headPhoto: Data? = nil
    
    /// 联系人姓名
    dynamic var name = ""
    
    /// 手机号
    dynamic var phone = ""
    
    /// 通话记录类型
    dynamic var callState = CallState.inUnConnected.rawValue
    
    /// 通话方式
    dynamic var callType = CallType.voice.rawValue
    
    /// 拨号方式
    dynamic var dialType = DialLine.p2p.rawValue
    
    /// 号码归属地
    dynamic var area = ""
    
    /// 通话开始时间
    dynamic var callStartTime = Date()
    
    /// 通话时长
    dynamic var callDuration = Date()
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
