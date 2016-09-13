//
//  GSCall.m
//  Gossip
//
//  Created by Chakrit Wichian on 7/9/12.
//

#import "GSCall.h"
#import "GSCall+Private.h"
#import "GSAccount+Private.h"
#import "GSDispatch.h"
#import "GSIncomingCall.h"
#import "GSOutgoingCall.h"
#import "GSRingback.h"
#import "GSUserAgent+Private.h"
#import "PJSIP.h"
#import "Util.h"


@implementation GSCall {
    pjsua_call_id _callId;
    float _volume;
    float _micVolume;
    float _volumeScale;
}

+ (GSCall *)outgoingCallToUri:(NSString *)remoteUri fromAccount:(GSAccount *)account {
    
    GSOutgoingCall *call = [GSOutgoingCall alloc];
    call = [call initWithRemoteUri:remoteUri fromAccount:account];
    
    return call;
}

+ (GSCall *)incomingCallWithId:(int)callId toAccount:(GSAccount *)account {
    GSIncomingCall *call = [GSIncomingCall alloc];
    call = [call initWithCallId:callId toAccount:account];

    return call;
}

- (NSString *)incomingCallInfo {
    pjsua_call_info callInfo;
    pjsua_call_get_info(_callId, &callInfo);
    NSString *remote_contact = [NSString stringWithUTF8String:callInfo.remote_info.ptr];
    NSLog(@"remote_contact:%@", remote_contact);
    NSString *contactId = [remote_contact substringWithRange:NSMakeRange(5, 11)];
    
    return contactId;
}

- (id)init {
    return [self initWithAccount:nil];
}

- (id)initWithAccount:(GSAccount *)account {
    if (self = [super init]) {
        GSAccountConfiguration *config = account.configuration;

        _account = account;
        _status = GSCallStatusReady;
        _callId = PJSUA_INVALID_ID;
        
        _ringback = nil;
        if (config.enableRingback) {
            _ringback = [GSRingback ringbackWithSoundNamed:config.ringbackFilename];
        }

        _volumeScale = [GSUserAgent sharedAgent].configuration.volumeScale;
        _volume = 1.0 / _volumeScale;
        _micVolume = 1.0 / _volumeScale;

        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self
                   selector:@selector(callStateDidChange:)
                       name:GSSIPCallStateDidChangeNotification
                     object:[GSDispatch class]];
        [center addObserver:self
                   selector:@selector(callMediaStateDidChange:)
                       name:GSSIPCallMediaStateDidChangeNotification
                     object:[GSDispatch class]];
    }
    return self;
}

- (void)dealloc {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];

    if (_ringback && _ringback.isPlaying) {
        [_ringback stop];
        _ringback = nil;
    }

    if (_callId != PJSUA_INVALID_ID && pjsua_call_is_active(_callId)) {
        GSLogIfFails(pjsua_call_hangup(_callId, 0, NULL, NULL));
    }
    
    _account = nil;
    _callId = PJSUA_INVALID_ID;
    _ringback = nil;
}


- (int)callId {
    return _callId;
}

- (void)setCallId:(int)callId {
    [self willChangeValueForKey:@"callId"];
    _callId = callId;
    [self didChangeValueForKey:@"callId"];
}

- (void)setStatus:(GSCallStatus)status {
    //[self willChangeValueForKey:@"status"];
    _status = status;
    //[self didChangeValueForKey:@"status"];
}

- (float)volume {
    return _volume;
}

- (BOOL)setVolume:(float)volume {
    [self willChangeValueForKey:@"volume"];
    BOOL result = [self adjustVolume:volume mic:_micVolume];
    [self didChangeValueForKey:@"volume"];
    
    return result;
}

- (float)micVolume {
    return _micVolume;
}

- (BOOL)setMicVolume:(float)micVolume {
    [self willChangeValueForKey:@"micVolume"];
    BOOL result = [self adjustVolume:_volume mic:micVolume];
    [self didChangeValueForKey:@"micVolume"];
    
    return result;
}


- (BOOL)begin {
    // for child overrides only
    return NO;
}

- (BOOL)end {
    // for child overrides only
    return NO;
}

- (void)setOutgoingVideoStream {
    const pj_str_t codec_id = {"H264", 4};
    pjmedia_vid_codec_param codec_param;
    pjsua_vid_codec_get_param(&codec_id, &codec_param);
    codec_param.enc_fmt.det.vid.size.w = 1280;
    codec_param.enc_fmt.det.vid.size.h = 720;
    codec_param.enc_fmt.det.vid.fps.num   = 30;
    codec_param.enc_fmt.det.vid.fps.denum = 1;
    codec_param.enc_fmt.det.vid.avg_bps = 512000;
    codec_param.enc_fmt.det.vid.max_bps = 1024000;
    pjsua_vid_codec_set_param(&codec_id, &codec_param);
    pjsua_call_vid_strm_op_param param;
    pjsua_call_vid_strm_op_param_default(&param);
    param.cap_dev = PJMEDIA_VID_DEFAULT_CAPTURE_DEV;
    param.dir = PJMEDIA_DIR_CAPTURE;
    //pjsua_call_set_vid_strm(_callId, PJSUA_CALL_VID_STRM_ADD, &param);
    pjsua_call_set_vid_strm(_callId, PJSUA_CALL_VID_STRM_START_TRANSMIT, &param);
}

- (void)setIncomingVideoStream {
    pjsua_call_vid_strm_op_param param;
    pjsua_call_vid_strm_op_param_default(&param);
    param.cap_dev = PJMEDIA_VID_DEFAULT_RENDER_DEV;
    param.dir = PJMEDIA_DIR_RENDER;
    //pjsua_call_set_vid_strm(_callId, PJSUA_CALL_VID_STRM_ADD, &param);
    pjsua_call_set_vid_strm(_callId, PJSUA_CALL_VID_STRM_START_TRANSMIT, &param);
}

- (UIView *)createVideoWindow {
    NSLog(@"_callId:%d", _callId);
    // 获取窗口ID
    int vid_idx;
    pjsua_vid_win_id wid = 0;
    vid_idx = pjsua_call_get_vid_stream_idx(_callId);
    NSLog(@"vid_idx:%d", vid_idx);
    pjsua_vid_win_id wids[100];
    unsigned count;
    pjsua_vid_enum_wins(wids, &count);
    for (int i=0; i<count; i++) {
        NSLog(@"wids[%d]:%d", i, wids[i]);
    }
    if (vid_idx >= 0){
        pjsua_call_info ci;
        pjsua_call_get_info(_callId, &ci);
        wid = ci.media[vid_idx].stream.vid.win_in;
    }
    
    NSLog(@"wid:%d", wid);
    //设置窗口位置大小
    pjmedia_coord rect;
    rect.x = 10;
    rect.y = 300;
    pjmedia_rect_size rect_size;
    rect_size.h = 600;
    rect_size.w = 250;
    pjsua_vid_win_set_size(wid,&rect_size);
    pjsua_vid_win_set_pos(wid,&rect);
    
    pjsua_vid_win_info win_info;
    pjsua_vid_win_get_info(wid, &win_info);
    UIView *view = (__bridge UIView *)win_info.hwnd.info.ios.window;
    win_info.is_native = PJ_FALSE;
    //显示窗口
    win_info.show = YES;
//    pjsua_vid_win_set_show(wid,PJ_TRUE);
    
    return view;
}

- (UIView *)createPreviewWindow {
    pjsua_vid_win_id wid = 0;
    pjsua_vid_preview_param preview_param;
    
    pjsua_vid_preview_param_default(&preview_param);
    preview_param.wnd_flags = PJMEDIA_VID_DEV_WND_BORDER |
    PJMEDIA_VID_DEV_WND_RESIZABLE;
    //preview_param.rend_id = PJMEDIA_VID_DEFAULT_CAPTURE_DEV;
    pjsua_vid_preview_start(PJMEDIA_VID_DEFAULT_CAPTURE_DEV, &preview_param);
    
    wid = pjsua_vid_preview_get_win(PJMEDIA_VID_DEFAULT_CAPTURE_DEV);
    pjmedia_coord rect;
    rect.x = 10;
    rect.y = 300;
    pjmedia_rect_size rect_size;
    rect_size.h = 600;
    rect_size.w = 250;
    pjsua_vid_win_set_size(wid,&rect_size);
    pjsua_vid_win_set_pos(wid,&rect);
    
    pjsua_vid_win_info win_info;
    pjsua_vid_win_get_info(wid, &win_info);
    UIView *view = (__bridge UIView *)win_info.hwnd.info.ios.window;
    win_info.is_native = PJ_FALSE;
    //显示窗口
    win_info.show = YES;
    
    
    return view;
}

- (BOOL)sendDTMFDigits:(NSString *)digits {
    pj_str_t pjDigits = [GSPJUtil PJStringWithString:digits];
    pjsua_call_dial_dtmf(_callId, &pjDigits);
    return true;
}


- (void)startRingback {
    if (!_ringback || _ringback.isPlaying)
        return;

    [_ringback play];
}

- (void)stopRingback {
    if (!(_ringback && _ringback.isPlaying))
        return;

    [_ringback stop];
}

- (void)callStateDidChange:(NSNotification *)notif {
    NSLog(@"callStateDidChange");
    pjsua_call_id callId = GSNotifGetInt(notif, GSSIPCallIdKey);
    pjsua_acc_id accountId = GSNotifGetInt(notif, GSSIPAccountIdKey);
    if (callId != _callId || accountId != _account.accountId)
        return;
    
    pjsua_call_info callInfo;
    pjsua_call_get_info(_callId, &callInfo);
    
    GSCallStatus callStatus;
    switch (callInfo.state) {
        case PJSIP_INV_STATE_NULL: {
            callStatus = GSCallStatusReady;
            
        } break;
            
        case PJSIP_INV_STATE_CALLING:
        case PJSIP_INV_STATE_INCOMING: {
            callStatus = GSCallStatusCalling;
        } break;
            
        case PJSIP_INV_STATE_EARLY:
        case PJSIP_INV_STATE_CONNECTING: {
            [self startRingback];
            callStatus = GSCallStatusConnecting;
        } break;
            
        case PJSIP_INV_STATE_CONFIRMED: {
            [self stopRingback];
            callStatus = GSCallStatusConnected;
        } break;
            
        case PJSIP_INV_STATE_DISCONNECTED: {
            [self stopRingback];
            callStatus = GSCallStatusDisconnected;
        } break;
    }
    
    __block id self_ = self;
    dispatch_async(dispatch_get_main_queue(), ^{ [self_ setStatus:callStatus]; });
}

- (void)callMediaStateDidChange:(NSNotification *)notif {
    pjsua_call_id callId = GSNotifGetInt(notif, GSSIPCallIdKey);
    if (callId != _callId)
        return;
    
    pjsua_call_info callInfo;
    NSLog(@"callMediaStateDidChange _callId:%d", _callId);
    GSReturnIfFails(pjsua_call_get_info(_callId, &callInfo));
    for (int mi=0; mi<callInfo.media_cnt; ++mi) {
        NSLog(@"callInfo.media[mi].type:%d", callInfo.media[mi].type);
        NSLog(@"callInfo.media[mi].stream.vid.win_in:%d", callInfo.media[mi].stream.vid.win_in);
        NSLog(@"callInfo.media[mi].stream.vid.cap_dev:%d", callInfo.media[mi].stream.vid.cap_dev);
        NSLog(@"callInfo.media[mi].dir:%d", callInfo.media[mi].dir);
    }
    
    
    if (callInfo.media_status == PJSUA_CALL_MEDIA_ACTIVE) {
        pjsua_conf_port_id callPort = pjsua_call_get_conf_port(_callId);
        GSReturnIfFails(pjsua_conf_connect(callPort, 0));
        GSReturnIfFails(pjsua_conf_connect(0, callPort));
        
        [self adjustVolume:_volume mic:_micVolume];
    }
}


- (BOOL)adjustVolume:(float)volume mic:(float)micVolume {
    GSAssert(0.0 <= volume && volume <= 1.0, @"Volume value must be between 0.0 and 1.0");
    GSAssert(0.0 <= micVolume && micVolume <= 1.0, @"Mic Volume must be between 0.0 and 1.0");
    
    _volume = volume;
    _micVolume = micVolume;
    if (_callId == PJSUA_INVALID_ID)
        return YES;
    
    pjsua_call_info callInfo;
    pjsua_call_get_info(_callId, &callInfo);
    if (callInfo.media_status == PJSUA_CALL_MEDIA_ACTIVE) {
        
        // scale volume as per configured volume scale
        volume *= _volumeScale;
        micVolume *= _volumeScale;
        pjsua_conf_port_id callPort = pjsua_call_get_conf_port(_callId);
        GSReturnNoIfFails(pjsua_conf_adjust_rx_level(callPort, volume));
        GSReturnNoIfFails(pjsua_conf_adjust_tx_level(callPort, micVolume));
    }
    
    // send volume change notification
    NSDictionary *info = nil;
    info = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithFloat:volume], GSVolumeKey,
            [NSNumber numberWithFloat:micVolume], GSMicVolumeKey, nil];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:GSVolumeDidChangeNotification
                          object:self
                        userInfo:info];
    
    return YES;
}

@end
