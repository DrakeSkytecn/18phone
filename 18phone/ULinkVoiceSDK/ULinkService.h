//
//  ULinkService.h
//  YouHuaYun
//
//  Created by yhy on 15-11-20.
//
//

#import "CommonClass.h"

@protocol ULinkServiceDelegate;
@interface ULinkService: NSObject

@property(nonatomic, assign) id <ULinkServiceDelegate> delegate;

+ (id)shareInstance;

//////////////////////////////////////////////////后台相关设定//////////////////////////////////////////////////

/**
 
 @brief 设置后台任务，以便在手机开机时能重新启动Tcp连接托管
 
 */
- (void) setBackgroundTask;

/**
 
 @brief 设置后台心跳发送，废弃了
 
 */
- (void) setBackgroundKeepAlive;

/**
 
 @brief 设置应用进入前台时，检查连接是否连接，如果没连接则会执行连接
 
 */
- (void) detectLinkAndRelink;


//////////////////////////////////////////////////相关ID设定////////////////////////////////////////////////////

/**
 
 @brief 初始化SDK时设定相关的ID
 
 @param devId     开发者ID
 
 @param appId      应用ID
 
 @param clientId   子账号ID
 
 @param clientPwd  子账号密码
 
 @return 返回值为0说明初始化成功
 */
- (int) setDevID:(NSString *)devId appId:(NSString *)appId clientId:(NSString *)clientId clientPwd:(NSString *)clientPwd;


//////////////////////////////////////////////////IM及通话相关API////////////////////////////////////////////////

/**
 
 @brief 判断应用是否在后台
 
 */
- (BOOL) isBackground;

/**
 
 @brief 启动Tcp连接，用户应用启动时，或退出登录重新进入等
 
 */
- (void) startLink;

/**
 
 @brief 断开Tcp连接，用户切到后台时，或退出登录等
 
 */
- (void) stopLink;

/**
 
 @brief 软件退出登录
 
 */
- (BOOL) sendLogOut;

/**
 
 @brief 呼叫发起
 
 @param toName     包含开发者ID、应用ID和子账号ID，中间用“#”号隔开
 
 @param toPhone    对方手机号码，用于直拨
 
 @param display   来电显示的号码
 
 @param attData   点对点呼叫透传过去的主叫数据串
 
 */
- (BOOL) sendCallInvite:(NSString *)toName toPhone:(NSString *)toPhone display:(NSString *)display attData:(NSString *)attData;

/**
 
 @brief 重发上次缓存下来的呼叫请求，用于：当被叫不在线时，先发送一个voip push，然后6s后调用这个API重发呼叫请求
 
 */
- (BOOL) reSendLastCallInvite;

/**
 
 @brief 呼叫接听
 
 */
- (BOOL) sendCallAnswer;

/**
 
 @brief 呼叫接通后的挂断
 
 */
- (BOOL) sendCallBye;

/**
 
 @brief 呼叫接通前的错误发送
 
 */
- (BOOL) sendCallFail:(NSString *)scode;

/**
 
 @brief 呼叫DTMF发送
 
 */
- (BOOL) sendCallDTMF:(NSString *)charStr;

/**
 
 @brief 获取本地呼叫方向，主叫或被叫
 
 */
- (CallDir) getLocalCallDir;

/**
 
 @brief 获取当前呼叫类型，点对点或直拨
 
 */
- (CallType) getCallType;

/**
 
 @brief 发起回拨
 
 @param caller    主叫号码
 
 @param callee    被叫号码
 
 @param callerDisplay   主叫端显示的号码
 
 @param calleeDisplay   被叫端显示的号码
 
 */

- (void)startCallBack:(NSString*)caller callee:(NSString*)callee callerDisplay:(NSString *)callerDisplay calleeDisplay:(NSString *)calleeDisplay;

/**
 
 @brief 挂断回拨
 
 @param callId     呼叫ID
 
 */
- (void)stopCallBack:(NSString*)callId;

//////////////////////////////////////////////////音频设置相关API////////////////////////////////////////////////
- (void) playP2PRingback:(NSString *)soundName soundType:(NSString *)ext;
- (void) playP2PRing:(NSString *)soundName soundType:(NSString *)ext;
- (void) stopP2PRingOrRingback;
- (void) playSoundVibrate;

- (void) setMute:(BOOL)value;
- (BOOL) getMuteValue;
- (void) setHandfree:(BOOL)value;
- (BOOL) getHandfreeValue;


@end


@protocol ULinkServiceDelegate <NSObject>
@optional

//////////////////////////////////////////////////http错误通知//////////////////////////////////////////////////

/**
 
 @brief 发起http请求，主要用户获取云服务的IP和Port，及登录令牌
 
 @param obj     通知回来的数据字典
 
 */
- (void)ULinkService:(ULinkService *)aObject startHttpRequest:(id)obj;

/**
 
 @brief http请求返回
 
 @param stateCode     通知回来的错误码，错误码为200即为获取成功，程序会静默执行TCP连接和登录
 
 */
- (void)ULinkService:(ULinkService *)aObject httpGetInitDataReturn:(int)stateCode;

/**
 
 @brief 回拨发起的回调
 
 @param msgDic     通知回来的数据字典
 
 */
- (void)ULinkService:(ULinkService *)aObject httpCallBackStartReturn:(id)msgDic;

/**
 
 @brief 回拨挂断的回调
 
 @param msgDic     通知回来的数据字典
 
 */
- (void)ULinkService:(ULinkService *)aObject httpCallBackStopReturn:(id)msgDic;

//////////////////////////////////////////////////tcp相关通知//////////////////////////////////////////////////

/**
 
 @brief 发起Tcp连接，注：连接成功后会自动登录
 
 @param obj     通知回来的数据字典
 
 */
- (void)ULinkService:(ULinkService *)aObject startTcpLink:(id)obj;

/**
 
 @brief 登录的返回
 
 @param stateCode     通知回来的错误码
 
 */
- (void)ULinkService:(ULinkService *)aObject receiveLoginAck:(int)stateCode;

/**
 
 @brief 收到服务器的踢人通知
 
 @param stateCode     通知回来的错误码
 
 */
- (void)ULinkService:(ULinkService *)aObject receiveKickOff:(int)stateCode;

/**
 
 @brief 收到服务器的下发的事件通知
 
 @param msgDic     通知回来的数据字典
 
 */
- (void)ULinkService:(ULinkService *)aObject receiveServerEvent:(id)msgDic;

/**
 
 @brief Tcp连接错误通知
 
 @param stateCode     通知回来的错误码
 
 */
- (void)ULinkService:(ULinkService *)aObject tcpNetworkError:(int)stateCode;

//////////////////////////////////////////////////呼叫相关通知//////////////////////////////////////////////////

/**
 
 @brief 呼叫呼入通知
 
 @param fromName     包含开发者ID、应用ID和子账号ID，中间用“#”号隔开
 
 @param display      呼叫显示号码，一般为手机号码
 
 @param attData      点对点呼叫透传过来的来自主叫的数据串
 
 */
- (void)ULinkService:(ULinkService *)aObject calleeReceiveIncomingCall:(NSString *)fromName display:(NSString *)display attData:(NSString *)attData;

/**
 
 @brief 呼叫状态通知
 
 @param callState     呼叫的状态
 
 */
- (void)ULinkService:(ULinkService *)aObject callReturnNotify:(CallState)callState stateCode:(int)stateCode;

@end
