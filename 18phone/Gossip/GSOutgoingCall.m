//
//  GSOutgoingCall.m
//  Gossip
//
//  Created by Chakrit Wichian on 7/12/12.
//

#import "GSOutgoingCall.h"
#import "GSCall+Private.h"
#import "PJSIP.h"
#import "Util.h"
#import "GSUserAgent.h"
#import "darwin_dev.h"

pj_status_t capturecb(pjmedia_vid_dev_stream *stream,
                      void *user_data,
                      pjmedia_frame *frame);

pj_status_t rendercb(pjmedia_vid_dev_stream *stream,
                     void *user_data,
                     pjmedia_frame *frame);


@implementation GSOutgoingCall {
    
}

@synthesize remoteUri = _remoteUri;

- (GSOutgoingCall *)initWithRemoteUri:(NSString *)remoteUri fromAccount:(GSAccount *)account {
    if (self = [super initWithAccount:account]) {
        _remoteUri = [remoteUri copy];
    }
    return self;
}

- (void)dealloc {
    _remoteUri = nil;
}

- (BOOL)begin {
    if (![_remoteUri hasPrefix:@"sip:"])
        _remoteUri = [@"sip:" stringByAppendingString:_remoteUri];
    
    pj_str_t remoteUri = [GSPJUtil PJStringWithString:_remoteUri];
    pjsua_call_setting callSetting;
    pjsua_call_setting_default(&callSetting);
    callSetting.aud_cnt = 1;
    callSetting.vid_cnt = 2; // TODO: Video calling support?
//    callSetting.flag = PJSUA_CALL_INCLUDE_DISABLED_MEDIA;
//    [[[GSUserAgent sharedAgent] account] setCavDeviceType:PJMEDIA_VID_DEFAULT_CAPTURE_DEV];
    
    pjsua_call_id callId;
    
    GSReturnNoIfFails(pjsua_call_make_call(self.account.accountId, &remoteUri, &callSetting, NULL, NULL, &callId));
    NSLog(@"pjsua_call_make_call");
    NSLog(@"pjsua_call_make_call %d", callId);
    [self setCallId:callId];
    pjsua_call_vid_strm_op_param param;
    pjsua_call_vid_strm_op_param_default(&param);
    param.cap_dev = PJMEDIA_VID_DEFAULT_CAPTURE_DEV;
    param.dir = PJMEDIA_DIR_CAPTURE;
    pjsua_call_set_vid_strm(callId, PJSUA_CALL_VID_STRM_SEND_KEYFRAME, &param);
//    pjsua_call_set_vid_strm(callId, PJSUA_CALL_VID_STRM_START_TRANSMIT, &param);
//    pj_caching_pool ch_pool;
//    pj_caching_pool_init(&ch_pool, NULL, 1024*1024);
//    pj_pool_factory *factory =&ch_pool.factory;
//    pjmedia_vid_dev_factory *f;
//    f = pjmedia_darwin_factory(factory);
//    darwin_factory_init(f);
//    pjmedia_vid_dev_param param;
//    pool = pjsua_pool_create("temp-18phone", 1000, 1000);
//    pjmedia_vid_dev_default_param(pool, 0, &param);
//    pjmedia_vid_dev_stream *vid_stream;
//    pjmedia_vid_dev_cb cb;
//    cb.capture_cb = &capturecb;
//    cb.render_cb = &rendercb;
//    darwin_factory_create_stream(f,&param, &cb, NULL, &vid_stream);
//    darwin_stream_start(vid_stream);
    
    return YES;
}

- (BOOL)end {
    NSAssert(self.callId != PJSUA_INVALID_ID, @"Call has not begun yet.");
    GSReturnNoIfFails(pjsua_call_hangup(self.callId, 0, NULL, NULL));
    [self setStatus:GSCallStatusDisconnected];
    [self setCallId:PJSUA_INVALID_ID];
    return YES;
}

pj_status_t capturecb(pjmedia_vid_dev_stream *stream,
                      void *user_data,
                      pjmedia_frame *frame) {
    return PJ_SUCCESS;
}

pj_status_t rendercb(pjmedia_vid_dev_stream *stream,
                     void *user_data,
                     pjmedia_frame *frame) {
    return PJ_SUCCESS;
}

@end
