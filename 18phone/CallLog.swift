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
    
    /// 来电未接通
    case inUnConnected
    
    /// 来电已接通
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
    
    /// 系统电话
    case system
}

/// 通话记录数据对象
class CallLog: Object {
    
    /// 注册后分配的账号ID
    dynamic var accountId = ""
    
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
    
    /// 通话结束时间
    dynamic var callEndTime = Date()
    
    /// 通话时长
    dynamic var callDuration = ""
}

struct CallLogInfo: JSONJoy{
    
    let CallType: Int?
    let Name: String?
    let IncomingType: Int?
    let BMobile: String?
    let CallTime: String?
    let TalkTimeLength: String?
    let EndTime: String?
    let Area: String?
    
    init(_ decoder: JSONDecoder) {
        CallType = decoder["CallType"].integer
        Name = decoder["Name"].string
        IncomingType = decoder["IncomingType"].integer
        BMobile = decoder["BMobile"].string
        CallTime = decoder["CallTime"].string
        TalkTimeLength = decoder["TalkTimeLength"].string
        EndTime = decoder["EndTime"].string
        Area = decoder["Area"].string
    }
}

struct CallLogInfos: JSONJoy {
    
    let codeStatus: Int?
    let codeinfo: String?
    var callLogInfos = [CallLogInfo]()
    
    init(_ decoder: JSONDecoder) {
        codeStatus = decoder["codeStatus"].integer
        codeinfo = decoder["codeInfo"].string
        if let tempCallLogInfos = decoder["listUserCallRecord"].array {
            for callLogInfoDecoder in tempCallLogInfos {
                callLogInfos.append(CallLogInfo(callLogInfoDecoder))
            }
        }
    }
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

struct DialBackCallInfo: JSONJoy {
    
    let status: String?
    let desc: String?
    let callId: String?
    let requestId: String?
    
    init(_ decoder: JSONDecoder) {
        status = decoder["status"].string
        desc = decoder["desc"].string
        callId = decoder["callId"].string
        requestId = decoder["requestId"].string
    }
}

struct CDR: JSONJoy {
    
    let caller: String?
    let holdTime: Int?
    let appId: String?
    let hangupCode: Int?
    let callerInviteTime: Int?
    let requestId: String?
    let calleeRingingBeginTime: Int?
    let callerHangupTime: Int?
    let recordFile: String?
    let state: Int?
    let calleeHangupTime: Int?
    let calleeDisplay: String?
    let userData: String?
    let callId: String?
    let fee: Double?
    let calleeAnswerTime: Int?
    let calleeInviteTime: Int?
    let callerRingingBeginTime: Int?
    let hangupReason: String?
    let callerAnswerTime: Int?
    let callee: String?
    let dtmf: String?
    let callerDisplay: String?
    let callType: Int?
    
    init(_ decoder: JSONDecoder) {
        caller = decoder["caller"].string
        holdTime = decoder["holdTime"].integer
        appId = decoder["appId"].string
        hangupCode = decoder["hangupCode"].integer
        callerInviteTime = decoder["callerInviteTime"].integer
        requestId = decoder["requestId"].string
        calleeRingingBeginTime = decoder["calleeRingingBeginTime"].integer
        callerHangupTime = decoder["callerHangupTime"].integer
        recordFile = decoder["recordFile"].string
        state = decoder["state"].integer
        calleeHangupTime = decoder["calleeHangupTime"].integer
        calleeDisplay = decoder["calleeDisplay"].string
        userData = decoder["userData"].string
        callId = decoder["callId"].string
        fee = decoder["fee"].double
        calleeAnswerTime = decoder["calleeAnswerTime"].integer
        calleeInviteTime = decoder["calleeInviteTime"].integer
        callerRingingBeginTime = decoder["callerRingingBeginTime"].integer
        hangupReason = decoder["hangupReason"].string
        callerAnswerTime = decoder["callerAnswerTime"].integer
        callee = decoder["callee"].string
        dtmf = decoder["dtmf"].string
        callerDisplay = decoder["callerDisplay"].string
        callType = decoder["callType"].integer
    }
}

struct CDRS: JSONJoy {
    
    let callId: String?
    let cdr: CDR?
    
    init(_ decoder: JSONDecoder) {
        callId = decoder["callId"].string
        cdr = CDR(decoder["cdr"])
    }
}

struct BackCallInfo: JSONJoy {
    
    let status: String?
    let desc: String?
    var cdrs = [CDRS]()
    
    init(_ decoder: JSONDecoder) {
        status = decoder["status"].string
        desc = decoder["desc"].string
        if let tempcdrs = decoder["cdrs"].array {
            for cdrDecoder in tempcdrs {
                cdrs.append(CDRS(cdrDecoder))
            }
        }
    }
}

