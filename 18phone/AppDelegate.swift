//
//  AppDelegate.swift
//  18phone
//
//  Created by 戴全艺 on 16/8/1.
//  Copyright © 2016年 Kratos. All rights reserved.
//

import UIKit
import PushKit
import CoreTelephony
import SwiftEventBus

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PKPushRegistryDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        print("didFinishLaunchingWithOptions")
        window?.backgroundColor = UIColor.white
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red: 38.0 / 255.0, green: 173.0 / 255.0, blue: 86.0 / 255.0, alpha: 1.0)], for: .selected)
        let userNotifiSetting = UIUserNotificationSettings(types: [.badge, .alert, .sound], categories: nil)
        application.registerUserNotificationSettings(userNotifiSetting)
        let pushRegistry = PKPushRegistry(queue: DispatchQueue.main)
        pushRegistry.delegate = self
        pushRegistry.desiredPushTypes = [.voIP]
        initShareService()
        let userDefaults = UserDefaults.standard
        if let userID = userDefaults.string(forKey: "userID") {
            let password = userDefaults.string(forKey: "password")
            App.initUserAgent(userID, password: password!)
            window?.rootViewController = R.storyboard.main.kTabBarController()
        } else {
            window?.rootViewController = R.storyboard.main.checkAccountViewController()
        }
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        print("applicationWillResignActive")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("applicationDidEnterBackground")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        print("applicationWillEnterForeground")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("applicationDidBecomeActive")
        SwiftEventBus.post("getBackCallInfo")
        SwiftEventBus.post("reloadCallLogs")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        print("didRegister notificationSettings")
        application.registerForRemoteNotifications()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.reduce(""){
            $0 + String(format:"%02.2hhx", $1)
        }
        print("APNSToken:\(token)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, forType type: PKPushType) {
        print("pushRegistry didUpdate")
        let token = credentials.token.reduce(""){
            $0 + String(format:"%02.2hhx", $1)
        }
        print("pushKitToken:\(token)")
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, forType type: PKPushType) {
        print("pushRegistry didReceiveIncomingPushWith")
    }
    
    /**
     初始化分享服务
     */
    func initShareService() {
        ShareSDK.registerApp("f88ec2241369", activePlatforms: [SSDKPlatformType.typeSinaWeibo.rawValue, SSDKPlatformType.typeQQ
            .rawValue, SSDKPlatformType.typeWechat.rawValue, SSDKPlatformType.typeTencentWeibo.rawValue], onImport: { platformType in
                switch platformType {
                case .typeSinaWeibo:
                    ShareSDKConnector.connectWeibo(WeiboSDK.classForCoder())
                    break;
                    
                case .typeQQ:
                    
                    ShareSDKConnector.connectQQ(QQApiInterface.classForCoder(), tencentOAuthClass: TencentOAuth.classForCoder())
                    
                    break;
                    
                case .typeWechat:
                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                    break;
                    
                default:
                    break;
                }
        }, onConfiguration: { platformType, appInfo in
            
            switch platformType {
                
            case .typeSinaWeibo:
                
                appInfo?.ssdkSetupSinaWeibo(byAppKey: "568898243", appSecret: "38a4f8204cc784f81f9f0daaf31e02e3", redirectUri: "http://www.sharesdk.cn", authType: SSDKAuthTypeBoth)
                
                break;
                
            case .typeQQ:
                
                appInfo?.ssdkSetupQQ(byAppId: "100371282",
                                           appKey : "aed9b0303e3ed1e27bae87c33761161d",
                                           authType : SSDKAuthTypeWeb)
                
                break;
                
            case .typeWechat:
                
                appInfo?.ssdkSetupWeChat(byAppId: "wx4868b35061f87885", appSecret: "64020361b8ec4c99936c0e3999a9f249")
                
                break;
                
            case .typeTencentWeibo:
                
                appInfo?.ssdkSetupTencentWeibo(byAppKey: "801307650",
                                                      appSecret : "ae36f4ee3946e1cbb98d6965b0b2ff5c",
                                                      redirectUri : "http://www.sharesdk.cn")
                
                break;
                
            default:
                break;
            }
        })
    }
}

