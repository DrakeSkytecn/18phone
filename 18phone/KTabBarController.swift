//
//  KTabBarController.swift
//  bottompopmenu
//
//  Created by Kratos on 7/10/16.
//  Copyright © 2016 Kratos. All rights reserved.
//

import UIKit

/// app第一级导航控制器
class KTabBarController: UITabBarController, ULinkServiceDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        App.ulinkService.delegate = self
        App.ulinkService.setDevID(App.ULINK_DEV_ID, appId: App.ULINK_APP_ID, clientId: UserDefaults.standard.string(forKey: "clientNumber"), clientPwd: UserDefaults.standard.string(forKey: "clientPwd"))
        App.ulinkService.startLink()
        //tabBar.tintColor = UIColor(red: 0, green: 128, blue: 0, alpha: 1)
//        for item in tabBar.items! {
//            print("KTabBarController item")
//            item.image?.imageWithRenderingMode(.AlwaysOriginal)
//            item.selectedImage?.imageWithRenderingMode(.AlwaysOriginal)
//        }
        selectedIndex = 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 1:
            (viewControllers![1].childViewControllers[0] as! RootViewController).changeMenuState(item)
        default:
            break
        }
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
    
    func uLinkService(_ aObject: ULinkService!, calleeReceiveIncomingCall fromName: String!, display: String!, attData: String!) {
        let incomingCallViewController = R.storyboard.main.incomingCallViewController()
        incomingCallViewController!.accountId = attData
        present(incomingCallViewController!, animated: true, completion: nil)
    }
    
    func uLinkService(_ aObject: ULinkService!, callReturnNotify callState: _CallState, stateCode: Int32) {
        print("callReturnNotify callState:\(callState) stateCode:\(stateCode)")
        
        switch callState
        {
        case CallStatusCode_CallProcess:
            break
        case CallStatusCode_Ringing:
//            App.ulinkService.playP2PRing("ringtone", soundType: "wav")
            //            if ([self getLocalCallDir]==CallDir_Caller)
            //            {
            //                [_callViewController setStatusTips:@"正在振铃..."];
            //
            //                //直拨不用本地响回铃音
            //                if ([self getCallType]==CallType_P2P)
            //                {
            //                    [self playP2PRingback:@"ring" soundType:@"wav"];
            //                }
            //            }
            //            else
            //            {
            ////                [_callViewController setStatusTips:@"电话呼入..."];
            //
            //                //响起铃声
            ////                if ([[ULinkService shareInstance] isBackground]==NO)
            ////                {
            ////                    [self playP2PRing:@"ring" soundType:@"wav"];
            ////                }
            //            }
            
            break
        case CallStatusCode_Talking:
            SwiftEventBus.post("talking")
//            App.ulinkService.stopP2PRingOrRingback()
            
            //            [_callViewController startSecondsTimer];
            
            //停止铃声或回铃音
            //            [self stopP2PRingOrRingback];
            
            break
        case CallStatusCode_CalleeRefuse:
            SwiftEventBus.post("noAnswer")
//            App.ulinkService.stopP2PRingOrRingback()
            //            [_callViewController setStatusTips:@"对方拒绝"];
            
            //停止铃声或回铃音
            //            [self stopP2PRingOrRingback];
            
            //            [self performSelector:@selector(dismissModalViewController) withObject:nil afterDelay:0.8];
            
            break
        case CallStatusCode_CallStop:
            SwiftEventBus.post("callStop")
//            App.ulinkService.stopP2PRingOrRingback()
            //            [_callViewController stopSecondsTimer];
            
            //            [_callViewController setStatusTips:@"通话结束"];
            
            //停止铃声或回铃音
            //            [self stopP2PRingOrRingback];
            
            //            [self performSelector:@selector(dismissModalViewController) withObject:nil afterDelay:0.8];
            
            //            [[LocalNotification shareInstance] stopLocalNotificationOfCall];
            break
        case CallStatusCode_CallTimeout:
            SwiftEventBus.post("noAnswer")
//            App.ulinkService.stopP2PRingOrRingback()
            //            [_callViewController setStatusTips:@"呼叫超时"];
            break
        case CallStatusCode_CalleeNoReply:
            SwiftEventBus.post("noAnswer")
//            App.ulinkService.stopP2PRingOrRingback()
            //            [_callViewController setStatusTips:@"对方无应答"];
            
            //停止铃声或回铃音
            //            [self stopP2PRingOrRingback];
            
            break
            
        default:
            break
        }
        
        switch stateCode {
        case 404:
            SwiftEventBus.post("offline")
            break
        default:
            break
        }
    }
}
