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
class AppDelegate: UIResponder, UIApplicationDelegate, PKPushRegistryDelegate, ULinkServiceDelegate {
    
    var window: UIWindow?
    
    var aTokenID: String?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        print("didFinishLaunchingWithOptions")
        window?.backgroundColor = UIColor.white
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red: 38.0 / 255.0, green: 173.0 / 255.0, blue: 86.0 / 255.0, alpha: 1.0)], for: .selected)
        let userNotifiSetting = UIUserNotificationSettings(types: [.badge, .alert, .sound], categories: nil)
        application.registerUserNotificationSettings(userNotifiSetting)
        let pushRegistry = PKPushRegistry(queue: DispatchQueue.main)
        pushRegistry.delegate = self
        pushRegistry.desiredPushTypes = [.voIP]
        App.ulinkService.delegate = self
        App.ulinkService.setBackgroundTask()
        App.ulinkService.setDevID("7d2f95120cec8f3e2703f58b4826bc6b", appId: "22ca0cb5a77fc6a9329345d4dc117188", clientId: "1664005609346033", clientPwd: "5h56ySCy")
        App.ulinkService.startLink()
        PhoneUtil.loginULink()
        initShareService()
        let userDefaults = UserDefaults.standard
        if let userID = userDefaults.string(forKey: "userID") {
            let password = userDefaults.string(forKey: "password")
            APIUtil.login(userDefaults.string(forKey: "username")!, password: password!, tokenID: userDefaults.string(forKey: "deviceToken")!, callBack: nil)
            App.initUserAgent(userID, password: password!)
            window?.rootViewController = R.storyboard.main.kTabBarController()
        } else {
            window?.rootViewController = R.storyboard.main.checkAccountViewController()
        }
        window?.makeKeyAndVisible()
        if let userInfo = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] {
            let userInfoDict = userInfo as! [String:Any]
            aTokenID = userInfoDict["aTokenID"] as? String
//            let alert = UIAlertController(title: "didFinishLaunchingWithOptions", message: userInfoDict.debugDescription, preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "好的", style: .default, handler: nil)
//            alert.addAction(okAction)
//            window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
        
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
        performSelector(onMainThread: #selector(AppDelegate.keepAlive), with: nil, waitUntilDone: true)
        application.setKeepAliveTimeout(600, handler: {
            self.performSelector(onMainThread: #selector(AppDelegate.keepAlive), with: nil, waitUntilDone: true)
        })
        App.ulinkService.setBackgroundKeepAlive()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        print("applicationWillEnterForeground")
        App.ulinkService.detectLinkAndRelink()
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
        let userDefaults = UserDefaults.standard
        if userDefaults.string(forKey: "deviceToken") == nil {
            userDefaults.set(token, forKey: "deviceToken")
            userDefaults.synchronize()
        }
        print("APNSToken:\(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("didFailToRegisterForRemoteNotificationsWithError:\(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        APIUtil.setOnline(UserDefaults.standard.string(forKey: "userID")!, callBack: nil)
//        aTokenID = userInfo[AnyHashable("aTokenID")] as? String
//        SwiftEventBus.post("buddyOnline")
        
//        let alert = UIAlertController(title: "didReceiveRemoteNotification", message: userInfo.debugDescription, preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "好的", style: .default, handler: nil)
//        alert.addAction(okAction)
//        window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
        print("handleActionWithIdentifier forRemoteNotification")
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
    
    func keepAlive() {
        App.userAgent?.keepAlive()
    }
    
    func showNotification()
    {
        // Create a new notification
        let alert = UILocalNotification()
        alert.repeatInterval = NSCalendar.Unit(rawValue: 0)
        alert.alertBody = "Incoming call received..."
        /* This action just brings the app to the FG, it doesn't
         * automatically answer the call (unless you specify the
         * --auto-answer option).
         */
        alert.alertAction = "Activate app"
        App.application.presentLocalNotificationNow(alert)
    }
    
    /**
     初始化分享服务
     */
    func initShareService() {
        ShareSDK.registerApp("f88ec2241369", activePlatforms: [SSDKPlatformType.typeSMS.rawValue, SSDKPlatformType.typeSinaWeibo.rawValue, SSDKPlatformType.typeQQ
            .rawValue, SSDKPlatformType.typeWechat.rawValue, SSDKPlatformType.typeTencentWeibo.rawValue], onImport: { platformType in
                switch platformType {
                case .typeSMS:
                    break
                    
                case .typeSinaWeibo:
                    ShareSDKConnector.connectWeibo(WeiboSDK.classForCoder())
                    break
                    
                case .typeQQ:
                    
                    ShareSDKConnector.connectQQ(QQApiInterface.classForCoder(), tencentOAuthClass: TencentOAuth.classForCoder())
                    
                    break
                    
                case .typeWechat:
                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                    break
                    
                default:
                    break
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
    
    // MARK: - ULinkServiceDelegate
    func uLinkService(_ aObject: ULinkService!, startHttpRequest obj: Any!) {
        print("startHttpRequest")
    }
    
    func uLinkService(_ aObject: ULinkService!, httpGetInitDataReturn stateCode: Int32) {
        print("httpGetInitDataReturn \(stateCode)")
    }
    
    func uLinkService(_ aObject: ULinkService!, httpCallBackStartReturn msgDic: Any!) {
        print("httpCallBackStartReturn")
    }
    
    func uLinkService(_ aObject: ULinkService!, httpCallBackStopReturn msgDic: Any!) {
        print("httpCallBackStopReturn")
    }
    
    func uLinkService(_ aObject: ULinkService!, startTcpLink obj: Any!) {
        print("startTcpLink")
    }
    
    func uLinkService(_ aObject: ULinkService!, receiveLoginAck stateCode: Int32) {
        print("receiveLoginAck")
    }
    
    func uLinkService(_ aObject: ULinkService!, receiveKickOff stateCode: Int32) {
        print("receiveKickOff")
    }
    
    func uLinkService(_ aObject: ULinkService!, receiveServerEvent msgDic: Any!) {
        print("receiveServerEvent")
    }
    
    func uLinkService(_ aObject: ULinkService!, tcpNetworkError stateCode: Int32) {
        print("tcpNetworkError \(stateCode)")
    }
    
    func uLinkService(_ aObject: ULinkService!, callReturnNotify callState: CallState, stateCode: Int32) {
        print("callReturnNotify callState:\(callState) stateCode:\(stateCode)")
    }
}

