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

@implementation GSOutgoingCall {
    
}

@synthesize remoteUri = _remoteUri;

- (GSOutgoingCall *)initWithRemoteUri:(NSString *)remoteUri fromAccount:(GSAccount *)account {
    if (self = [super initWithAccount:account]) {
        _remoteUri = [remoteUri copy];
        if (![_remoteUri hasPrefix:@"sip:"]) {
            _remoteUri = [@"sip:" stringByAppendingString:_remoteUri];
        }
    }
    return self;
}

- (void)dealloc {
    _remoteUri = nil;
}

- (BOOL)begin {
    pj_str_t remoteUri = [GSPJUtil PJStringWithString:_remoteUri];
    pjsua_call_setting call_setting;
    pjsua_call_setting_default(&call_setting);
    call_setting.aud_cnt = 1;
    call_setting.vid_cnt = 0;
    pjsua_call_id callId;
    GSReturnNoIfFails(pjsua_call_make_call(self.account.accountId, &remoteUri, &call_setting, "fuck", NULL, &callId));
    [self setCallId:callId];
    
    return YES;
}

- (BOOL)beginVideo {
    pj_str_t remoteUri = [GSPJUtil PJStringWithString:_remoteUri];
    pjsua_call_setting call_setting;
    pjsua_call_setting_default(&call_setting);
    call_setting.aud_cnt = 1;
    call_setting.vid_cnt = 1;
    pjsua_call_id callId;
    GSReturnNoIfFails(pjsua_call_make_call(self.account.accountId, &remoteUri, &call_setting, NULL, NULL, &callId));
    [self setCallId:callId];
    
    return YES;
}

- (BOOL)end {
    if (self.callId != PJSUA_INVALID_ID) {
        GSReturnNoIfFails(pjsua_call_hangup(self.callId, 0, NULL, NULL));
        [self setStatus:GSCallStatusDisconnected];
        [self setCallId:PJSUA_INVALID_ID];
    }
    return YES;
}

@end
