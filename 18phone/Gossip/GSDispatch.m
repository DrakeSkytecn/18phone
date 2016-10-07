//
//  GSDispatch.m
//  Gossip
//
//  Created by Chakrit Wichian on 7/6/12.
//

#import "GSDispatch.h"
#import "GSPJUtil.h"

void onRegistrationStarted(pjsua_acc_id accountId, pj_bool_t renew);
void onRegistrationState(pjsua_acc_id accountId);
void onRegistrationState2(pjsua_acc_id accountId, pjsua_reg_info *info);
void onIncomingCall(pjsua_acc_id accountId, pjsua_call_id callId, pjsip_rx_data *rdata);
void onCallMediaState(pjsua_call_id callId);
void onCallState(pjsua_call_id callId, pjsip_event *e);
void onBuddyState(pjsua_buddy_id buddy_id);
void onIncomingSubscribe(pjsua_acc_id acc_id,
                         pjsua_srv_pres *srv_pres,
                         pjsua_buddy_id buddy_id,
                         const pj_str_t *from,
                         pjsip_rx_data *rdata,
                         pjsip_status_code *code,
                         pj_str_t *reason,
                         pjsua_msg_data *msg_data_);


static dispatch_queue_t _queue = NULL;

@implementation GSDispatch

+ (void)initialize {
    _queue = dispatch_queue_create("GSDispatch", DISPATCH_QUEUE_SERIAL);
}

+ (void)configureCallbacksForAgent:(pjsua_config *)uaConfig {
    uaConfig->cb.on_reg_started = &onRegistrationStarted;
    uaConfig->cb.on_reg_state = &onRegistrationState;
    //uaConfig->cb.on_reg_state2 = &onRegistrationState2;
    uaConfig->cb.on_incoming_call = &onIncomingCall;
    uaConfig->cb.on_call_media_state = &onCallMediaState;
    uaConfig->cb.on_call_state = &onCallState;
    uaConfig->cb.on_buddy_state = &onBuddyState;
    uaConfig->cb.on_incoming_subscribe = &onIncomingSubscribe;
}


#pragma mark - Dispatch sink

// TODO: May need to implement some form of subscriber filtering
//   orthogonaly/globally if we're to scale. But right now a few
//   dictionary lookups on the receiver side probably wouldn't hurt much.

+ (void)dispatchRegistrationStarted:(pjsua_acc_id)accountId renew:(pj_bool_t)renew {
    NSLog(@"Gossip: dispatchRegistrationStarted(%d, %d)", accountId, renew);
    
    NSDictionary *info = nil;
    info = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInt:accountId], GSSIPAccountIdKey,
            [NSNumber numberWithBool:renew], GSSIPRenewKey, nil];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:GSSIPRegistrationDidStartNotification
                          object:self
                        userInfo:info];
}

+ (void)dispatchRegistrationState:(pjsua_acc_id)accountId {
    NSLog(@"Gossip: dispatchRegistrationState(%d)", accountId);
    
    NSDictionary *info = nil;
    info = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:accountId]
                                       forKey:GSSIPAccountIdKey];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:GSSIPRegistrationStateDidChangeNotification
                          object:self
                        userInfo:info];
}

+ (void)dispatchIncomingCall:(pjsua_acc_id)accountId
                      callId:(pjsua_call_id)callId
                        data:(pjsip_rx_data *)data {
    NSDictionary *info = nil;
    info = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInt:accountId], GSSIPAccountIdKey,
            [NSNumber numberWithInt:callId], GSSIPCallIdKey,
            [NSValue valueWithPointer:data], GSSIPDataKey, nil];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:GSSIPIncomingCallNotification
                          object:self
                        userInfo:info];
}

+ (void)dispatchCallMediaState:(pjsua_call_id)callId {
    NSLog(@"Gossip: dispatchCallMediaState(%d)", callId);
    
    NSDictionary *info = nil;
    info = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:callId]
                                       forKey:GSSIPCallIdKey];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:GSSIPCallMediaStateDidChangeNotification
                          object:self
                        userInfo:info];
}

+ (void)dispatchCallState:(pjsua_call_id)callId event:(pjsip_event *)e {
    NSLog(@"Gossip: dispatchCallState(%d)", callId);
    
    NSDictionary *info = nil;
    info = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInt:callId], GSSIPCallIdKey,
            [NSValue valueWithPointer:e], GSSIPDataKey, nil];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:GSSIPCallStateDidChangeNotification
                          object:self
                        userInfo:info];
}

+ (void)dispatchBuddyState:(pjsua_buddy_id)buddyId {
    NSDictionary *dict = nil;
    dict = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInt:buddyId], GSSIPBuddyIdKey, nil];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:GSSIPBuddyStateDidChangeNotification
                          object:self
                        userInfo:dict];
}

@end


#pragma mark - C event bridge

// Bridge C-land callbacks to ObjC-land.

static inline void dispatch(dispatch_block_t block) {
    // autorelease here since events wouldn't be triggered that often.
    // + GCD autorelease pool do not have drainage time guarantee (== possible mem headaches).
    // See the "Implementing tasks using blocks" section for more info
    // REF: http://developer.apple.com/library/ios/#documentation/General/Conceptual/ConcurrencyProgrammingGuide/OperationQueues/OperationQueues.html
    @autoreleasepool {
        
        // NOTE: Needs to use dispatch_sync() instead of dispatch_async() because we do not know
        //   the lifetime of the stuff being given to us by PJSIP (e.g. pjsip_rx_data*) so we
        //   must process it completely before the method ends.
        dispatch_sync(_queue, block);
    }
}

void onRegistrationStarted(pjsua_acc_id accountId, pj_bool_t renew) {
    dispatch(^{ [GSDispatch dispatchRegistrationStarted:accountId renew:renew]; });
}

void onRegistrationState(pjsua_acc_id accountId) {
    dispatch(^{ [GSDispatch dispatchRegistrationState:accountId]; });
}

void onRegistrationState2(pjsua_acc_id accountId, pjsua_reg_info *info) {
    dispatch(^{ [GSDispatch dispatchRegistrationState:accountId]; });
}

void onIncomingCall(pjsua_acc_id accountId, pjsua_call_id callId, pjsip_rx_data *rdata) {
    dispatch(^{ [GSDispatch dispatchIncomingCall:accountId callId:callId data:rdata]; });
}

void onCallMediaState(pjsua_call_id callId) {
    dispatch(^{ [GSDispatch dispatchCallMediaState:callId]; });
}

void onCallState(pjsua_call_id callId, pjsip_event *e) {
    dispatch(^{ [GSDispatch dispatchCallState:callId event:e]; });
}

void onBuddyState(pjsua_buddy_id buddy_id) {
    [GSDispatch dispatchBuddyState:buddy_id];
}

void onIncomingSubscribe(pjsua_acc_id acc_id,
                         pjsua_srv_pres *srv_pres,
                         pjsua_buddy_id buddy_id,
                         const pj_str_t *from,
                         pjsip_rx_data *rdata,
                         pjsip_status_code *code,
                         pj_str_t *reason,
                         pjsua_msg_data *msg_data_) {
    NSLog(@"onIncomingSubscribe");
}
