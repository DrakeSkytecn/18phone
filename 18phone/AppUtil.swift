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
import SwiftDate
import SwiftHTTP
import JSONJoy
import Async

/**
 *  app中使用到的URL的定义
 */
struct URL {
    
    /// 百度提供的查询号码归属地api
    static let phoneAreaUrl = "http://apis.baidu.com/apistore/mobilenumber/mobilenumber"
    
    /// 比一比SIP服务器地址
    static let BEYEBE_SIP_SERVER = "211.149.172.109:5060"
    //    static let BEYEBE_SIP_SERVER = "192.168.10.204:5060"
    //    static let BEYEBE_SIP_SERVER = "192.168.10.239:5060"
    
    /// 比一比SIP服务器域名
    static let BEYEBE_SIP_DOMAIN = "18phone.beyebe"
    //    static let BEYEBE_SIP_DOMAIN = "myvoipapp.com"
    
    /// 18phone接口地址
    static let BEYEBE_18PHONE_API_BASE = "http://192.168.10.249/api/Phone/"
//    static let BEYEBE_18PHONE_API_BASE = "http://18phone.beyebe.cn/api/Phone/"
}

/**
 *  app系统常量的定义
 */
struct App {
    static let application = UIApplication.shared
    static let appDelegate = application.delegate as! AppDelegate
    static let APIStoreKey = "1fc3cdcb8b5ec8466b083a04a9b4e1a8"
    static let realm = try! Realm()
    static let userAgent = GSUserAgent.shared()
    static let userAgentAccount = GSUserAgent.shared().account
    static let statusBarHeight = application.statusBarFrame.height
    static let navigationBarHeight: CGFloat = 44.0
    static var isSpeakerOn = false
    
    static func initUserAgent(_ username: String, password: String) {
        let userAgent = GSUserAgent.shared()
        let configuration = GSConfiguration.default()
        let accountConfiguration = GSAccountConfiguration.default()
        accountConfiguration?.address = username + "@" + URL.BEYEBE_SIP_DOMAIN
        accountConfiguration?.username = username
        accountConfiguration?.password = password
        accountConfiguration?.domain = URL.BEYEBE_SIP_DOMAIN
        accountConfiguration?.proxyServer = URL.BEYEBE_SIP_SERVER
        accountConfiguration?.enableRingback = true
        configuration?.account = accountConfiguration
        configuration?.logLevel = 5
        userAgent?.configure(configuration)
        userAgent?.start()
    }
    
    static func autoLogin(_ username: String, password: String) {
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
    
    static func getAgeFromBirthday(_ date: Date) -> String {
        let dateDiff = date.timeIntervalSinceNow
        let age = String(Int(abs(trunc(dateDiff/(60*60*24))/365)))
        
        return age
    }
}

/**
 *  号码相关的工具方法定义
 */
struct PhoneUtil {
    static func getPhoneAreaInfo(_ phoneNumber: String, callBack: ((PhoneAreaInfo) -> ())?) {
        do{
            let opt = try HTTP.GET(URL.phoneAreaUrl, parameters: ["phone":phoneNumber], headers: ["apikey": App.APIStoreKey])
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
        return phoneNumber.replacingOccurrences(of: "^\\+8[56][2]*|\\W+|\\s/g", with: "", options: .regularExpression, range: nil)
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

struct APIUtil {
    static func getVerifyCodeInfo(_ phoneNumber: String, callBack: ((VerifyCodeInfo) -> ())?) {
        do {
            let opt = try HTTP.GET(URL.BEYEBE_18PHONE_API_BASE + "getVerificationCode", parameters: ["accountNumber":phoneNumber])
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
    
    static func register(_ phoneNumber: String, password: String, verificationCode: String, deviceId: String) {
        do {
            let opt = try HTTP.GET(URL.BEYEBE_18PHONE_API_BASE + "register", parameters: ["accountNumber":phoneNumber, "password":password, "verificationCode":verificationCode, "DeviceID":deviceId])
            opt.start { response in
                if let error = response.error {
                    print("error: \(error.localizedDescription)")
                    print("error: \(error.code)")
                    
                    return
                }
                print(response.text)
                //                let verifyCodeInfo = VerifyCodeInfo(JSONDecoder(response.data))
                //                if callBack != nil {
                //                    Async.main {
                //                        callBack!(verifyCodeInfo)
                //                    }
                //                }
            }
        } catch {
            print("got an error creating the request: \(error)")
        }
    }
    
    static func login(_ phoneNumber: String, password: String, callBack: ((LoginInfo) -> ())?) {
        do {
            let opt = try HTTP.GET(URL.BEYEBE_18PHONE_API_BASE + "login", parameters: ["PhoneNumber":phoneNumber, "password":password])
            opt.start { response in
                if let error = response.error {
                    print("error: \(error.localizedDescription)")
                    print("error: \(error.code)")
                    
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
            let opt = try HTTP.GET(URL.BEYEBE_18PHONE_API_BASE + "getServiceEndTime", parameters: ["userID":userID])
            opt.start { response in
                if let error = response.error {
                    print("error: \(error.localizedDescription)")
                    print("error: \(error.code)")
                    
                    return
                }
                print(response.text)
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
}



