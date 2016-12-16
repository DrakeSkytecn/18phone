//
//  AppUtil.swift
//  FastFramework
//
//  Created by 戴全艺 on 16/2/29.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import Foundation
import AVFoundation
import RealmSwift

/**
 *  app中使用到的URL的定义
 */
struct AppURL {
    
    /// 百度提供的查询号码归属地api
    static let BAIDU_PHONEAREA_API = "http://apis.baidu.com/apistore/mobilenumber/mobilenumber"
    
    /// 比一比SIP服务器地址
    static let BEYEBE_SIP_SERVER = "211.149.172.109:5060"
//            static let BEYEBE_SIP_SERVER = "192.168.10.249:5060"
    //    static let BEYEBE_SIP_SERVER = "192.168.10.239:5060"
    
    /// 比一比SIP服务器域名
    static let BEYEBE_SIP_DOMAIN = "18phone.beyebe"
//            static let BEYEBE_SIP_DOMAIN = "myvoipapp.com"
    
    /// 18phone接口地址
    static let BEYEBE_18PHONE_API_BASE = "http://192.168.10.249/Home/"
//        static let BEYEBE_18PHONE_API_BASE = "http://18phone.beyebe.cn/Home/"
    
    static let ZHIYU_BASE_URL = "http://www.zypaas.com:9988/V1/Account/"
    
    static let ULINK_LOGIN_URL = "https://app.youlianyun.com/mutual/testinfo.php"
}

/**
 *  app系统常量的定义
 */
struct App {
    static let application = UIApplication.shared
    static let appDelegate = application.delegate as! AppDelegate
    static let APIStoreKey = "1fc3cdcb8b5ec8466b083a04a9b4e1a8"
    static let ZHIYU_API_ACCOUNT = "ACC755b7ec7456240b99db0eb8edd8f37a9"
    static let ZHIYU_API_KEY = "API11387e576dcd4dd886c02ea63a433e24"
    static let ZHIYU_APP_ID = "APP1e811237a2674f5c824b512a7916c5a8"
    static let ULINK_ACCOUNT = "13489385888@qq.com"
    static let ULINK_PASSWORD = "a12345678"
    static let realm = try! Realm()
    static let userAgent = GSUserAgent.shared()
    static let userAgentAccount = GSUserAgent.shared().account
    static let ulinkService = ULinkService.shareInstance() as! ULinkService
    static let statusBarHeight = application.statusBarFrame.height
    static let navigationBarHeight: CGFloat = 44.0
    static var isSpeakerOn = false
    
    static func initUserAgent(_ username: String, password: String) {
        let userAgent = GSUserAgent.shared()
        let configuration = GSConfiguration.default()
        let accountConfiguration = GSAccountConfiguration.default()
        accountConfiguration?.address = username + "@" + AppURL.BEYEBE_SIP_DOMAIN
        accountConfiguration?.username = username
        accountConfiguration?.password = password
        accountConfiguration?.domain = AppURL.BEYEBE_SIP_DOMAIN
        accountConfiguration?.proxyServer = AppURL.BEYEBE_SIP_SERVER
        accountConfiguration?.enableRingback = true
        configuration?.account = accountConfiguration
        configuration?.logLevel = 5
        userAgent?.configure(configuration)
        userAgent?.start()
    }
    
    static func autoLogin(_ userID: String, username: String, password: String) {
        let userDefaults = UserDefaults.standard
        if let saveUsername = userDefaults.string(forKey: "username") {
            let savePassword = userDefaults.string(forKey: "password")
            initUserAgent(saveUsername, password: savePassword!)
        } else {
            userDefaults.set(username, forKey: "username")
            userDefaults.set(password, forKey: "password")
            userDefaults.synchronize()
            initUserAgent(username, password: password)
        }
    }
    
    static func changeSpeaker(_ isOn: Bool) {
        let port = isOn ? AVAudioSessionPortOverride.speaker : AVAudioSessionPortOverride.none
        isSpeakerOn = isOn
        try! AVAudioSession.sharedInstance().overrideOutputAudioPort(port)
    }
}

/**
 *  app界面常量的定义
 */
struct Screen {
    static let width = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height
    static let bounds = UIScreen.main.bounds
}

/**
 *  日期相关的工具方法定义
 */
struct DateUtil {
    
    static var sharedDateFormatterInstance: DateFormatter?
    
    static func shareDateFormatter() -> DateFormatter {
        if sharedDateFormatterInstance == nil {
            sharedDateFormatterInstance = DateFormatter()
        }
        return sharedDateFormatterInstance!
    }
    
    static func getCurrentDate() -> Date {
        let date = Date()
        let zone = TimeZone.current
        let interval = zone.secondsFromGMT(for: date)
        let localeDate = date.addingTimeInterval(TimeInterval(interval))
        print("getCurrentDate():" + localeDate.description)
        return date
    }
    
    static func dateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let secondsPerDay: TimeInterval = 24 * 60 * 60
        let today = Date()
        let yesterday = today.addingTimeInterval(-secondsPerDay)
        
        if date.year == today.year {
            switch date.day {
            case today.day:
                return "今天 " + dateFormatter.string(from: date)
            case yesterday.day:
                return "昨天 " + dateFormatter.string(from: date)
            default:
                dateFormatter.dateFormat = "MM/dd HH:mm"
                return dateFormatter.string(from: date)
            }
        } else {
            dateFormatter.dateFormat = "yyyy MM/dd"
            return dateFormatter.string(from: date)
        }
    }
    
    static func getAgeFromBirthday(_ date: Date) -> Int {
        let dateDiff = date.timeIntervalSinceNow
        let age = Int(abs(trunc(dateDiff/(60*60*24))/365))
        
        return age
    }
}

/**
 *  号码相关的工具方法定义
 */
struct PhoneUtil {
    static func getPhoneAreaInfo(_ phoneNumber: String, callBack: ((PhoneAreaInfo) -> ())?) {
        do{
            let opt = try HTTP.GET(AppURL.BAIDU_PHONEAREA_API, parameters: ["phone":phoneNumber], headers: ["apikey": App.APIStoreKey])
            opt.start { response in
                if let error = response.error {
                    print("error: \(error.localizedDescription)")
                    print("error: \(error.code)")
                    
                    return
                }
                
                print(response.text)
                let phoneAreaInfo = PhoneAreaInfo(JSONDecoder(response.data))
                if callBack != nil {
                    Async.main {
                        callBack!(phoneAreaInfo)
                    }
                }
            }
        } catch {
            print("got an error creating the request: \(error)")
        }
    }
    
    static func formatPhoneNumber(_ phoneNumber: String) -> String {
        return phoneNumber.replacingOccurrences(of: "^\\W+|\\s/g", with: "", options: .regularExpression, range: nil)
    }
    
    static func isMobileNumber(_ phoneNumber: String?) -> Bool {
        let pattern = "^(1[34578]\\d{9})$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: phoneNumber)
    }
    
    static func isTelephoneNumber(_ telephoneNumber: String?) -> Bool {
        let pattern = "^(0[0-9]{2,3})?([2-9][0-9]{6,7})+([0-9]{1,4})$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: telephoneNumber)
    }
    
    static func isNumber(_ number: String?) -> Bool {
        let pattern = "^\\d{1,12}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: number)
    }
    
    static func callSystemPhone(_ number: String) {
        UIApplication.shared.openURL(Foundation.URL(string: "tel://" + number)!)
    }
    
    static func dialBackCall(_ fromNumber: String, toNumber: String, callBack: ((DialBackCallInfo) -> ())?) {
        //        请求消息头:
        //        POST /.../callback/call HTTP/1.1
        //        Content-Length: 256
        //        Content-Type: application/json; charset=UTF-8
        //        Host: 172.18.0.134:8080
        //        Connection: Keep-Alive
        //        User-Agent: Apache-HttpClient/4.5 (Java/1.7.0_79)
        //        Accept-Encoding: gzip,deflate
        //        请求消息体:
        //        {
        //            "apiAccount": "ACC19a660c5b79947768bda869f3128a868",
        //            "appId": "APP49933e2f3c674b49b1620f38ff320c99",
        //            "requestId": "123",
        //            "userData": "userData",
        //            "caller": "15899774455",
        //            "callerDisplay": "13826504034",
        //            "callee": "13826504034",
        //            "calleeDisplay": "15899774455",
        //            "maxDuration": 600,
        //            "promptTone": "xxx.wav",
        //            "recordFlag": 0,
        //            "timeStamp": "1467177012406",
        //            "sign": "bca84dc426a7ce176b01f1b8187f9623"
        //        }
        let timeStamp = Date().timeIntervalSince1970 / 1000
        let sign = MathUtil.md5(App.ZHIYU_API_ACCOUNT + App.ZHIYU_API_KEY + "\(timeStamp)").uppercased()
        do {
            let opt = try HTTP.POST(AppURL.ZHIYU_BASE_URL + App.ZHIYU_API_ACCOUNT + "/callback/call", parameters:["apiAccount":App.ZHIYU_API_ACCOUNT, "appId":App.ZHIYU_APP_ID, "requestId":"18phone", "userData":"userData", "caller":fromNumber, "callerDisplay":toNumber, "callee":toNumber, "calleeDisplay":fromNumber, "maxDuration":600, "promptTone":"", "recordFlag":1, "cdrUrl":"", "sign":sign, "timeStamp":"\(timeStamp)"], headers:["Content-Length":"256", "Content-Type":"application/json; charset=utf-8", "Host":"172.18.0.134:8080", "Connection":"Keep-Alive", "Accept-Encoding":"gzip,deflate"], requestSerializer:JSONParameterSerializer())
            opt.start { response in
                if let error = response.error {
                    print("error: \(error.localizedDescription)")
                    print("error: \(error.code)")
                    
                    return
                }
                print(response.text!)
                let dialBackCallInfo = DialBackCallInfo(JSONDecoder(response.data))
                if callBack != nil {
                    Async.main {
                        callBack!(dialBackCallInfo)
                    }
                }
            }
        } catch {
            print("got an error creating the request: \(error)")
        }
    }
    
    static func getBackCallInfo(_ callId: String, callBack: ((BackCallInfo) -> ())?) {
        //        3、请求示例
        //
        //        请求消息头:
        //        POST /cdr HTTP/1.1
        //        Content-Length: 256
        //        Content-Type: application/json; charset=UTF-8
        //        Host: 172.18.0.134:8080
        //        Connection: Keep-Alive
        //        User-Agent: Apache-HttpClient/4.5 (Java/1.7.0_79)
        //        Accept-Encoding: gzip,deflate
        //        请求消息体:
        //        {
        //            "apiAccount": "ACC19a660c5b79947768bda869f3128a869",
        //            "appId": "APP49933e2f3c674b49b1620f38ff320c99",
        //            "callId": "14738178086511111312878516015899774959,14732982703030011312878516015899774959",
        //            "timeStamp": "1476091190611",
        //            "sign": "0ACC5F9D61684A5552230ADFF40D9148"
        //        }
        let timeStamp = Date().timeIntervalSince1970 / 1000
        let sign = MathUtil.md5(App.ZHIYU_API_ACCOUNT + App.ZHIYU_API_KEY + "\(timeStamp)").uppercased()
        do {
            let opt = try HTTP.POST(AppURL.ZHIYU_BASE_URL + "cdrQuery/voiceCallbackCdr", parameters:["apiAccount":App.ZHIYU_API_ACCOUNT, "appId":App.ZHIYU_APP_ID, "callId":callId, "timeStamp":"\(timeStamp)", "sign":sign], headers:["Content-Length":"256", "Content-Type":"application/json; charset=utf-8", "Host":"172.18.0.134:8080", "Connection":"Keep-Alive", "Accept-Encoding":"gzip,deflate"], requestSerializer:JSONParameterSerializer())
            opt.start { response in
                if let error = response.error {
                    print("error: \(error.localizedDescription)")
                    print("error: \(error.code)")
                    
                    return
                }
                print(response.text!)
                let backCallInfo = BackCallInfo(JSONDecoder(response.data))
                if callBack != nil {
                    Async.main {
                        callBack!(backCallInfo)
                    }
                }
            }
        } catch {
            print("got an error creating the request: \(error)")
        }
    }
    
    static func hangupBackCall(_ callId: String, callBack: ((DialBackCallInfo) -> ())?) {
        //        3、请求示例
        //
        //        请求消息头:
        //        POST /.../callback/cancel HTTP/1.1
        //        Content-Length: 156
        //        Content-Type: application/json; charset=UTF-8
        //        Host: 172.18.0.134:8080
        //        Connection: Keep-Alive
        //        User-Agent: Apache-HttpClient/4.5 (Java/1.7.0_79)
        //        Accept-Encoding: gzip,deflate
        //        请求消息体:
        //        {
        //            "apiAccount": "ACC19a660c5b79947768bda869f3128a868",
        //            "appId": "APP49933e2f3c674b49b1620f38ff320c99",
        //            "requestId": "123",
        //            "callId": "1467177012406431100513826504034",
        //            "timeStamp": "1467177012406",
        //            "sign": "bca84dc426a7ce176b01f1b8187f9623"
        //        }
        let timeStamp = Date().timeIntervalSince1970 / 1000
        let sign = MathUtil.md5(App.ZHIYU_API_ACCOUNT + App.ZHIYU_API_KEY + "\(timeStamp)").uppercased()
        do {
            let opt = try HTTP.POST(AppURL.ZHIYU_BASE_URL + App.ZHIYU_API_ACCOUNT + "/callback/cancel", parameters:["apiAccount":App.ZHIYU_API_ACCOUNT, "appId":App.ZHIYU_APP_ID, "requestId":"18phone", "callId":callId, "timeStamp":"\(timeStamp)", "sign":sign], headers:["Content-Length":"156", "Content-Type":"application/json; charset=utf-8", "Host":"172.18.0.134:8080", "Connection":"Keep-Alive", "Accept-Encoding":"gzip,deflate"], requestSerializer:JSONParameterSerializer())
            opt.start { response in
                if let error = response.error {
                    print("error: \(error.localizedDescription)")
                    print("error: \(error.code)")
                    
                    return
                }
                print(response.text!)
                let dialBackCallInfo = DialBackCallInfo(JSONDecoder(response.data))
                if callBack != nil {
                    Async.main {
                        callBack!(dialBackCallInfo)
                    }
                }
            }
        } catch {
            print("got an error creating the request: \(error)")
        }
    }
    
    static func loginULink() {
        do {
            let opt = try HTTP.POST(AppURL.ULINK_LOGIN_URL, parameters:["account":App.ULINK_ACCOUNT, "password":App.ULINK_PASSWORD], headers:["Content-Type":"application/json; charset=utf-8", "Accept":"application/json"], requestSerializer:JSONParameterSerializer())
            opt.start { response in
                if let error = response.error {
                    print("error: \(error.localizedDescription)")
                    print("error: \(error.code)")
                    
                    return
                }
                print(response.text!)
//                let dialBackCallInfo = DialBackCallInfo(JSONDecoder(response.data))
//                if callBack != nil {
//                    Async.main {
//                        callBack!(dialBackCallInfo)
//                    }
//                }
            }
        } catch {
            print("got an error creating the request: \(error)")
        }
    }
}

struct StringUtil {
    static func HanToPin(_ string: String) -> NSString? {
        let temp = NSMutableString(utf8String: string)
        if CFStringTransform(temp, nil, kCFStringTransformMandarinLatin, false) {
            if CFStringTransform(temp, nil, kCFStringTransformStripDiacritics, false) {
                return temp! as NSString
            } else {
                return ""
            }
        } else {
            return ""
        }
    }
}

struct ViewUtil {
    /**
     Number Pad没有return键需手动添加
     
     - parameter textField: 需要添加return键的textField
     */
    static func setupNumberBar(_ textField: UITextField) {
        let numberBar = R.nib.numberBar.firstView(owner: nil)
        var temp = numberBar!.frame
        temp.size.width = Screen.width
        numberBar?.frame = temp
        numberBar?.textField = textField
        textField.inputAccessoryView = numberBar
    }
}

struct MathUtil {
    static func md5(_ string:String) -> String {
        let str = string.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(string.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deinitialize()
        return String(format: hash as String)
    }
}

struct APIUtil {
    
    static func getVerifyCodeInfo(_ phoneNumber: String, callBack: ((VerifyCodeInfo) -> ())?){
        do {
            let opt = try HTTP.GET(AppURL.BEYEBE_18PHONE_API_BASE + "getVerificationCode", parameters: ["accountNumber":phoneNumber])
            opt.start { response in
                if let error = response.error {
                    print("error: \(error.localizedDescription)")
                    print("error: \(error.code)")
                    
                    return
                }
                print(response.text)
                let verifyCodeInfo = VerifyCodeInfo(JSONDecoder(response.data))
                if callBack != nil {
                    Async.main {
                        callBack!(verifyCodeInfo)
                    }
                }
            }
        } catch {
            print("got an error creating the request: \(error)")
        }
    }
    
    static func register(_ phoneNumber: String, password: String, verificationCode: String, deviceId: String, callBack: ((RegisterInfo) -> ())?) {
        do {
            let opt = try HTTP.POST(AppURL.BEYEBE_18PHONE_API_BASE + "register", parameters: ["accountNumber":phoneNumber, "password":password, "verificationCode":verificationCode, "DeviceID":deviceId, "phoneType":0])
            opt.start { response in
                if let error = response.error {
                    print("error: \(error.localizedDescription)")
                    print("error: \(error.code)")
                    
                    return
                }
                print(response.text)
                let registerInfo = RegisterInfo(JSONDecoder(response.data))
                if callBack != nil {
                    Async.main {
                        callBack!(registerInfo)
                    }
                }
            }
        } catch {
            print("got an error creating the request: \(error)")
        }
    }
    
    static func login(_ phoneNumber: String, password: String, tokenID: String, callBack: ((LoginInfo?) -> ())?) {
        do {
            let opt = try HTTP.POST(AppURL.BEYEBE_18PHONE_API_BASE + "login", parameters: ["PhoneNumber":phoneNumber, "password":password, "tokenID":tokenID, "phoneType":0])
            opt.start { response in
                if let error = response.error {
                    print("error: \(error.localizedDescription)")
                    print("error: \(error.code)")
                    if callBack != nil {
                        Async.main {
                            callBack!(nil)
                        }
                    }
                    return
                }
                print(response.text)
                let loginInfo = LoginInfo(JSONDecoder(response.data))
                if callBack != nil {
                    Async.main {
                        callBack!(loginInfo)
                    }
                }
            }
        } catch {
            print("got an error creating the request: \(error)")
        }
    }
    
    static func getDayLeft(_ userID: String, callBack: ((DayLeft) -> ())?) {
        do {
            let opt = try HTTP.POST(AppURL.BEYEBE_18PHONE_API_BASE + "getServiceEndTime", parameters: ["userID":userID])
            opt.start { response in
                if let error = response.error {
                    print("error: \(error.localizedDescription)")
                    print("error: \(error.code)")
                    
                    return
                }
                print(response.text!)
                let dayLeft = DayLeft(JSONDecoder(response.data))
                if callBack != nil {
                    Async.main {
                        callBack!(dayLeft)
                    }
                }
            }
        } catch {
            print("got an error creating the request: \(error)")
        }
    }
    
    static func getUserInfo(_ userID: String, callBack: ((UserInfo) -> ())?) {
        do {
            let opt = try HTTP.POST(AppURL.BEYEBE_18PHONE_API_BASE + "getPersonSelfInfo", parameters: ["userID":userID])
            opt.start { response in
                if let error = response.error {
                    print("error: \(error.localizedDescription)")
                    print("error: \(error.code)")
                    
                    return
                }
                print(response.text!)
                let userInfo = UserInfo(JSONDecoder(response.data))
                if callBack != nil {
                    Async.main {
                        callBack!(userInfo)
                    }
                }
            }
        } catch {
            print("got an error creating the request: \(error)")
        }
    }
    
    static func resetPassword(_ phoneNumber: String, password: String, verificationCode: String, callBack: ((ResetPassword) -> ())?) {
        do {
            let opt = try HTTP.POST(AppURL.BEYEBE_18PHONE_API_BASE + "modifiPassWordByPhone", parameters: ["mobilePhone":phoneNumber, "newPassW":password, "verificationCode":verificationCode])
            opt.start { response in
                if let error = response.error {
                    print("error: \(error.localizedDescription)")
                    print("error: \(error.code)")
                    
                    return
                }
                print(response.text!)
                let resetPassword = ResetPassword(JSONDecoder(response.data))
                if callBack != nil {
                    Async.main {
                        callBack!(resetPassword)
                    }
                }
            }
        } catch {
            print("got an error creating the request: \(error)")
        }
    }
    
    static func changePassword(_ userID: String, oldPassword: String, newPassword: String, callBack: ((ResetPassword) -> ())?) {
        do {
            let opt = try HTTP.POST(AppURL.BEYEBE_18PHONE_API_BASE + "modifiPassWordByUserID", parameters: ["userID":userID, "oldPassW":oldPassword, "newPassW":newPassword])
            opt.start { response in
                if let error = response.error {
                    print("error: \(error.localizedDescription)")
                    print("error: \(error.code)")
                    
                    return
                }
                print(response.text!)
                let resetPassword = ResetPassword(JSONDecoder(response.data))
                if callBack != nil {
                    Async.main {
                        callBack!(resetPassword)
                    }
                }
            }
        } catch {
            print("got an error creating the request: \(error)")
        }
    }
    
    static func changePhoneNumber(_ userID: String, phoneNumber: String, password: String, verificationCode: String, callBack: ((ResetPassword) -> ())?) {
        do {
            let opt = try HTTP.POST(AppURL.BEYEBE_18PHONE_API_BASE + "modifiedMobile", parameters: ["userID":userID, "newMobile":phoneNumber, "password":password, "verificationCode":verificationCode])
            opt.start { response in
                if let error = response.error {
                    print("error: \(error.localizedDescription)")
                    print("error: \(error.code)")
                    
                    return
                }
                print(response.text!)
                let resetPassword = ResetPassword(JSONDecoder(response.data))
                if callBack != nil {
                    Async.main {
                        callBack!(resetPassword)
                    }
                }
            }
        } catch {
            print("got an error creating the request: \(error)")
        }
    }
    
    static func editUserInfo(_ userInfo: [String: Any], callBack: ((EditUser) -> ())?) {
        do {
            let opt = try HTTP.POST(AppURL.BEYEBE_18PHONE_API_BASE + "updatePersonSelfInfo", parameters: userInfo)
            opt.start { response in
                if let error = response.error {
                    print("error: \(error.localizedDescription)")
                    print("error: \(error.code)")
                    
                    return
                }
                print(response.text!)
                let editUser = EditUser(JSONDecoder(response.data))
                if callBack != nil {
                    Async.main {
                        callBack!(editUser)
                    }
                }
            }
        } catch {
            print("got an error creating the request: \(error)")
        }
    }
    
    static func getContactID(_ phoneNumber: String, callBack: ((ContactIDInfo) -> ())?) {
        do {
            let opt = try HTTP.POST(AppURL.BEYEBE_18PHONE_API_BASE + "getUserID", parameters: ["mobile":phoneNumber])
            opt.start { response in
                if let error = response.error {
                    print("error: \(error.localizedDescription)")
                    print("error: \(error.code)")
                    
                    return
                }
                print(response.text)
                let contactIDInfo = ContactIDInfo(JSONDecoder(response.data))
                if callBack != nil {
                    Async.main {
                        callBack!(contactIDInfo)
                    }
                }
            }
        } catch {
            print("got an error creating the request: \(error)")
        }
    }
    
    static func saveCallLog(_ callInfo: [String:Any]) {
        do {
            let opt = try HTTP.POST(AppURL.BEYEBE_18PHONE_API_BASE + "putUser_CallRecord", parameters: callInfo)
            opt.start { response in
                if let error = response.error {
                    print("error: \(error.localizedDescription)")
                    print("error: \(error.code)")
                    
                    return
                }
                print(response.text)
            }
        } catch {
            print("got an error creating the request: \(error)")
        }
    }
    
    static func getCallLogByMonth(_ userID: String, year: Int, month: Int, callBack: ((CallLogInfos) -> ())?) {
        do {
            let opt = try HTTP.POST(AppURL.BEYEBE_18PHONE_API_BASE + "getSomeMonthCallRecord", parameters: ["userID":userID, "year":year, "month":month])
            opt.start { response in
                if let error = response.error {
                    print("error: \(error.localizedDescription)")
                    print("error: \(error.code)")
                    
                    return
                }
                print(response.text!)
                let callLogInfos = CallLogInfos(JSONDecoder(response.data))
                if callBack != nil {
                    Async.main {
                        callBack!(callLogInfos)
                    }
                }
            }
        } catch {
            print("got an error creating the request: \(error)")
        }
    }
    
    static func uploadContact(_ jsonStr: String, callBack: ((BackupContactInfo) -> ())?) {
        do {
            let opt = try HTTP.POST(AppURL.BEYEBE_18PHONE_API_BASE + "backupContactsBook", parameters: ["jsonStr":jsonStr])
            opt.start { response in
                if let error = response.error {
                    print("error: \(error.localizedDescription)")
                    print("error: \(error.code)")
                    
                    return
                }
                print(response.text!)
                let backupContactInfo = BackupContactInfo(JSONDecoder(response.data))
                if callBack != nil {
                    Async.main {
                        callBack!(backupContactInfo)
                    }
                }
            }
        } catch {
            print("got an error creating the request: \(error)")
        }
    }
    
    static func downloadContact(_ userID: String, callBack: ((DownloadContactInfos) -> ())?) {
        do {
            let opt = try HTTP.POST(AppURL.BEYEBE_18PHONE_API_BASE + "downloadContactsBook", parameters: ["userID":userID])
            opt.start { response in
                if let error = response.error {
                    print("error: \(error.localizedDescription)")
                    print("error: \(error.code)")
                    
                    return
                }
                print(response.text!)
                let downloadContactInfos = DownloadContactInfos(JSONDecoder(response.data))
                if callBack != nil {
                    Async.main {
                        callBack!(downloadContactInfos)
                    }
                }
            }
        } catch {
            print("got an error creating the request: \(error)")
        }
    }
    
    static func p2pCall(_ AUserID: String, BUserID: String, callBack: ((VerifyCodeInfo) -> ())?) {
        do {
            let opt = try HTTP.POST(AppURL.BEYEBE_18PHONE_API_BASE + "pushXinGeMessage", parameters: ["AUserID":AUserID, "BUserID":BUserID])
            opt.start { response in
                if let error = response.error {
                    print("error: \(error.localizedDescription)")
                    print("error: \(error.code)")
                    
                    return
                }
                print(response.text!)
                let verifyCodeInfo = VerifyCodeInfo(JSONDecoder(response.data))
                if callBack != nil {
                    Async.main {
                        callBack!(verifyCodeInfo)
                    }
                }
            }
        } catch {
            print("got an error creating the request: \(error)")
        }
    }
    
    static func buddyIsOnline(_ userID: String, callBack: ((VerifyCodeInfo) -> ())?) {
        do {
            let opt = try HTTP.GET(AppURL.BEYEBE_18PHONE_API_BASE + "isOnline", parameters: ["userID":userID])
            opt.start { response in
                if let error = response.error {
                    print("error: \(error.localizedDescription)")
                    print("error: \(error.code)")
                    
                    return
                }
                print(response.text!)
                let verifyCodeInfo = VerifyCodeInfo(JSONDecoder(response.data))
                if callBack != nil {
                    Async.main {
                        callBack!(verifyCodeInfo)
                    }
                }
            }
        } catch {
            print("got an error creating the request: \(error)")
        }
    }
    
    static func setOnline(_ userID: String, callBack: ((VerifyCodeInfo) -> ())?) {
        do {
            let opt = try HTTP.GET(AppURL.BEYEBE_18PHONE_API_BASE + "setCache", parameters: ["userID":userID])
            opt.start { response in
                if let error = response.error {
                    print("error: \(error.localizedDescription)")
                    print("error: \(error.code)")
                    
                    return
                }
                print(response.text!)
                let verifyCodeInfo = VerifyCodeInfo(JSONDecoder(response.data))
                if callBack != nil {
                    Async.main {
                        callBack!(verifyCodeInfo)
                    }
                }
            }
        } catch {
            print("got an error creating the request: \(error)")
        }
    }
}

struct NetworkUtil {
    
    static func checkSpeed() {
        var start = 0.0
        do {
            let opt = try HTTP.Download("http://pic55.nipic.com/file/20141208/19462408_171130083000_2.jpg") { url in
                let speed = (8918 / 1024) / (Date().timeIntervalSince1970 - start)
                print("speed:\(speed)")
            }
            opt.start()
            start = Date().timeIntervalSince1970
        } catch {
            print("got an error creating the request: \(error)")
        }
    }
}
