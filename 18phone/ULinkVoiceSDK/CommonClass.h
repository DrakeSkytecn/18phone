//
//  ULinkService.h
//  YouHuaYun
//
//  Created by yhy on 15-11-20.
//
//

#define call_statecode_unknown -1

typedef enum _HttpState
{
    HttpStatusCode_UnKnown = 713,                //未知错误
    HttpStatusCode_GetDataSuccess = 200,         //当前无网络
    HttpStatusCode_GetInitDataFail= 706,         //Http获取数据失败
    HttpStatusCode_GetDataTimeout = 408,         //Http登录超时
    HttpStatusCode_GetDataFail = 500,            //Http获取数据失败
} HttpState;

typedef enum _TcpState
{
    TcpStatusCode_UnKnown = 713,                //未知错误
    TcpStatusCode_NetworkNotAvailable = 710,    //当前无网络
    TcpStatusCode_StartTcpReConnect = 708,      //Tcp重连
    TcpStatusCode_LinkCountMax = 709,           //Tcp尝试连接达到最大次数
    TcpStatusCode_LoginSuccess = 200,           //604登录成功
    TcpStatusCode_LoginFail = 505,              //Tcp登录失败
    TcpStatusCode_LoginTimeout = 408,           //Tcp登录超时
    TcpStatusCode_ConnectError = 800,           //Tcp连接错误，SDK内部使用，开发者无需处理
} TcpState;

typedef enum _CallDir
{
    CallDir_UnKnown = -1,
    CallDir_Caller,         //主叫
    CallDir_Callee,         //被叫
} CallDir;

typedef enum _CallType
{
    CallType_UnKnown = -1,
    CallType_Direct,      //直拨
    CallType_P2P,         //点对点
} CallType;

typedef enum _CallState
{
    CallStatusCode_UnKnown = -1,       //未知错误
    CallStatusCode_Idle = 0,           //空闲状态，随时可以发起或接受呼叫
    CallStatusCode_CallProcess,        //呼叫开始，主叫发出Invite，被叫接收Invite
    CallStatusCode_Ringing,            //被叫正在振铃,主叫显示正在振铃
    CallStatusCode_Talking,            //通话已建立，主叫收到Answer，被叫发出Answer
    CallStatusCode_CalleeRefuse,       //被叫拒绝接听，主叫收到Refuse，被叫发出Refuse，错误码606
    CallStatusCode_CallStop,           //通话结束
    CallStatusCode_CallTimeout,        //呼叫超时，无法连通对方
    CallStatusCode_CalleeNoReply,      //呼叫无应答，被叫振铃但没接听
} CallState;
