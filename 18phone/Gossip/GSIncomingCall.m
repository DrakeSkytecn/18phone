//
//  GSIncomingCall.m
//  Gossip
//
//  Created by Chakrit Wichian on 7/12/12.
//

#import "GSIncomingCall.h"
#import "GSCall+Private.h"
#import "PJSIP.h"
#import "Util.h"
#import "GSUserAgent.h"

@implementation GSIncomingCall

- (GSIncomingCall *)initWithCallId:(int)callId toAccount:(GSAccount *)account {
    if (self = [super initWithAccount:account]) {
        [self setCallId:callId];
    }
    return self;
}

- (BOOL)begin {
    NSAssert(self.callId != PJSUA_INVALID_ID, @"Call has already ended.");
    pjsua_call_setting call_setting;
    pjsua_call_setting_default(&call_setting);
    call_setting.aud_cnt = 1;
    call_setting.vid_cnt = 1;
//    [[[GSUserAgent sharedAgent] account] setCavDeviceType:PJMEDIA_VID_DEFAULT_RENDER_DEV];
    
    
    GSReturnNoIfFails(pjsua_call_answer2(self.callId, &call_setting, 200, NULL, NULL));
    
//    pjsua_call_vid_strm_op_param param;
//    pjsua_call_vid_strm_op_param_default(&param);
//    //param.cap_dev = PJMEDIA_VID_DEFAULT_RENDER_DEV;
//    param.dir = PJMEDIA_DIR_RENDER;
//    param.med_idx = -1;
//    pjsua_call_set_vid_strm(self.callId, PJSUA_CALL_VID_STRM_START_TRANSMIT, &param);
    
    return YES;
}

- (BOOL)end {
    NSAssert(self.callId != PJSUA_INVALID_ID, @"Call has already ended.");
    
    GSReturnNoIfFails(pjsua_call_hangup(self.callId, 0, NULL, NULL));
    
    [self setStatus:GSCallStatusDisconnected];
    [self setCallId:PJSUA_INVALID_ID];
    return YES;
}

@end
