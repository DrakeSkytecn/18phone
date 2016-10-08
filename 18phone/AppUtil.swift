//
//  AppUtil.swift
//  FastFramework
//
//  Created by 戴全艺 on 16/2/29.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftDate

/**
 *  app中使用到的URL的定义
 */
struct URL {
    
    /// 百度提供的查询号码归属地api
    static let phoneAreaUrl = "http://apis.baidu.com/apistore/mobilenumber/mobilenumber"
    
    /// 比一比SIP服务器地址
//    static let BEYEBE_SIP_SERVER = "211.149.172.109:5060"
    static let BEYEBE_SIP_SERVER = "192.168.10.239:5060"
//    static let BEYEBE_SIP_SERVER = "192.168.0.113:5060"
    
    /// 比一比SIP服务器域名
//    static let BEYEBE_SIP_DOMAIN = "18phone.beyebe"
    static let BEYEBE_SIP_DOMAIN = "myvoipapp.com"
}

/**
 *  app系统常量的定义
 */
struct App {
    static let application = UIApplication.sharedApplication()
    static let appDelegate = application.delegate as! AppDelegate
    static let APIStoreKey = "1fc3cdcb8b5ec8466b083a04a9b4e1a8"
    static let realm = try! Realm()
    static let userAgent = GSUserAgent.sharedAgent()
    static let userAgentAccount = GSUserAgent.sharedAgent().account
    static let statusBarHeight = application.statusBarFrame.height
    static let navigationBarHeight: CGFloat = 44.0
    
    static func initUserAgent(username: String, password: String) {
        let userAgent = GSUserAgent.sharedAgent()
        let configuration = GSConfiguration.defaultConfiguration()
        let accountConfiguration = GSAccountConfiguration.defaultConfiguration()
        accountConfiguration.address = username + "@" + URL.BEYEBE_SIP_DOMAIN
        accountConfiguration.username = username
        accountConfiguration.password = password
        accountConfiguration.domain = URL.BEYEBE_SIP_DOMAIN
        accountConfiguration.proxyServer = URL.BEYEBE_SIP_SERVER
        accountConfiguration.enableRingback = true
        configuration.account = accountConfiguration
        configuration.logLevel = 5
        userAgent.configure(configuration)
        userAgent.start()
    }
    
    static func autoLogin(username: String, password: String) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let saveUsername = userDefaults.stringForKey("username") {
            let savePassword = userDefaults.stringForKey("password")
            initUserAgent(saveUsername, password: savePassword!)
        } else {
            userDefaults.setObject(username, forKey: "username")
            userDefaults.setObject(password, forKey: "password")
            userDefaults.synchronize()
            initUserAgent(username, password: password)
        }
    }
}

/**
 *  app界面常量的定义
 */
struct Screen {
    static let width = UIScreen.mainScreen().bounds.width
    static let height = UIScreen.mainScreen().bounds.height
}

/**
 *  日期相关的工具方法定义
 */
struct DateUtil {
    
    static var sharedDateFormatterInstance: NSDateFormatter?
    
    static func shareDateFormatter() -> NSDateFormatter {
        if sharedDateFormatterInstance == nil {
            sharedDateFormatterInstance = NSDateFormatter()
        }
        return sharedDateFormatterInstance!
    }
    
    static func getCurrentDate() -> NSDate {
        let date = NSDate()
        let zone = NSTimeZone.systemTimeZone()
        let interval = zone.secondsFromGMTForDate(date)
        let localeDate = date.dateByAddingTimeInterval(NSTimeInterval(interval))
        print("getCurrentDate():" + localeDate.description)
        return date
    }
    
    static func dateToString(date: NSDate) -> String {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let secondsPerDay: NSTimeInterval = 24 * 60 * 60
        let today = NSDate()
        let yesterday = today.dateByAddingTimeInterval(-secondsPerDay)
        
        if date.year == today.year {
            switch date.day {
            case today.day:
                return "今天 " + dateFormatter.stringFromDate(date)
            case yesterday.day:
                return "昨天 " + dateFormatter.stringFromDate(date)
            default:
                dateFormatter.dateFormat = "MM/dd HH:mm"
                return dateFormatter.stringFromDate(date)
            }
        } else {
            dateFormatter.dateFormat = "yyyy MM/dd"
            return dateFormatter.stringFromDate(date)
        }
    }
    
    static func getAgeFromBirthday(date: NSDate) -> String {
        let dateDiff = date.timeIntervalSinceNow
        let age = String(Int(abs(trunc(dateDiff/(60*60*24))/365)))
        
        return age
    }
}

/**
 *  号码相关的工具方法定义
 */
struct PhoneUtil {
    static func getPhoneAreaInfo(phoneNumber: String, callBack: ((PhoneAreaInfo) -> ())?) {
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
    
    static func formatPhoneNumber(phoneNumber: String) -> String {
        return phoneNumber.stringByReplacingOccurrencesOfString("^\\+8[56][2]*|\\W+|\\s/g", withString: "", options: .RegularExpressionSearch, range: nil)
    }
    
    static func isMobileNumber(phoneNumber: String?) -> Bool {
        let pattern = "^(1[34578]\\d{9})$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluateWithObject(phoneNumber)
    }
    
    static func isTelephoneNumber(telephoneNumber: String?) -> Bool {
        let pattern = "^(0[0-9]{2,3})?([2-9][0-9]{6,7})+([0-9]{1,4})$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluateWithObject(telephoneNumber)
    }
    
    static func isNumber(number: String?) -> Bool {
        let pattern = "^\\d{1,12}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluateWithObject(number)
    }
    
    static func callSystemPhone(number: String) {
        UIApplication.sharedApplication().openURL(NSURL(string: "tel://" + number)!)
    }
}

struct StringUtil {
    static func HanToPin(string: String) -> NSString? {
        let temp = NSMutableString(UTF8String: string)
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



