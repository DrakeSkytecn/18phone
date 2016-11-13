//
//  GSUserAgent.m
//  Gossip
//
//  Created by Chakrit Wichian on 7/5/12.
//

#import "GSUserAgent.h"
#import "GSUserAgent+Private.h"
#import "GSCodecInfo.h"
#import "GSCodecInfo+Private.h"
#import "GSDispatch.h"
#import "PJSIP.h"
#import "Util.h"


@implementation GSUserAgent {
    GSConfiguration *_config;
    pjsua_transport_id _transportId;
}

@synthesize account = _account;
@synthesize status = _status;

+ (GSUserAgent *)sharedAgent {
    static dispatch_once_t onceToken;
    static GSUserAgent *agent = nil;
    dispatch_once(&onceToken, ^{ agent = [[GSUserAgent alloc] init]; });
    
    return agent;
}


- (id)init {
    if (self = [super init]) {
        _account = nil;
        _config = nil;
        
        _transportId = PJSUA_INVALID_ID;
        _status = GSUserAgentStateUninitialized;
    }
    return self;
}

- (void)dealloc {
    if (_transportId != PJSUA_INVALID_ID) {
        pjsua_transport_close(_transportId, PJ_TRUE);
        _transportId = PJSUA_INVALID_ID;
    }
    
    if (_status >= GSUserAgentStateConfigured) {
        pjsua_destroy();
    }
    
    _account = nil;
    _config = nil;
    _status = GSUserAgentStateDestroyed;
}


- (GSConfiguration *)configuration {
    return _config;
}

- (GSUserAgentState)status {
    return _status;
}

- (void)setStatus:(GSUserAgentState)status {
    [self willChangeValueForKey:@"status"];
    _status = status;
    [self didChangeValueForKey:@"status"];
}


- (BOOL)configure:(GSConfiguration *)config {
    GSAssert(!_config, @"Gossip: User agent is already configured.");
    _config = [config copy];
    // create agent
    GSReturnNoIfFails(pjsua_create());
    [self setStatus:GSUserAgentStateCreated];
    
    // configure agent
    pjsua_config uaConfig;
    pjsua_logging_config logConfig;
    pjsua_media_config mediaConfig;
    
    pjsua_config_default(&uaConfig);
    pj_str_t stun = pj_str("stun.counterpath.com");
    uaConfig.stun_srv_cnt = 1;
    uaConfig.stun_srv[0] = stun;
    
    [GSDispatch configureCallbacksForAgent:&uaConfig];
    
    pjsua_logging_config_default(&logConfig);
    logConfig.level = _config.logLevel;
    logConfig.console_level = _config.consoleLogLevel;
    
    pjsua_media_config_default(&mediaConfig);
    mediaConfig.clock_rate = _config.clockRate;
    mediaConfig.snd_clock_rate = _config.soundClockRate;
    //mediaConfig.ec_tail_len = 5000; // not sure what this does (Siphon use this.)
    
    GSReturnNoIfFails(pjsua_init(&uaConfig, &logConfig, &mediaConfig));
    
    // Configure the DNS resolvers to also handle SRV records
    pjsip_endpoint* endpoint = pjsua_get_pjsip_endpt();
    pj_dns_resolver* resolver;
    pj_str_t google_dns = [GSPJUtil PJStringWithString:@"119.29.29.29"];
    struct pj_str_t servers[] = { google_dns };
//    GSReturnNoIfFails(pjsip_endpt_create_resolver(endpoint, &resolver));
//    GSReturnNoIfFails(pj_dns_resolver_set_ns(resolver, 1, servers, nil));
//    GSReturnNoIfFails(pjsip_endpt_set_resolver(endpoint, resolver));
    
    // create UDP transport
    // TODO: Make configurable? (which transport type to use/other transport opts)
    // TODO: Make separate class? since things like public_addr might be useful to some.
    pjsua_transport_config transportConfig;
    pjsua_transport_config_default(&transportConfig);
    transportConfig.port = 5060;
    pjsip_transport_type_e transportType = 0;
    switch (_config.transportType) {
        case GSUDPTransportType: transportType = PJSIP_TRANSPORT_UDP; break;
        case GSUDP6TransportType: transportType = PJSIP_TRANSPORT_UDP6; break;
        case GSTCPTransportType: transportType = PJSIP_TRANSPORT_TCP; break;
        case GSTCP6TransportType: transportType = PJSIP_TRANSPORT_TCP6; break;
    }
    
    GSReturnNoIfFails(pjsua_transport_create(PJSIP_TRANSPORT_UDP, &transportConfig, &_transportId));
    
    pjsua_transport_config udp_cfg;
    udp_cfg = transportConfig;
    udp_cfg.port = 5070;
    
    GSReturnNoIfFails(pjsua_transport_create(PJSIP_TRANSPORT_UDP6, &udp_cfg, &_transportId));
    
    pjsua_transport_config tcp_cfg;
    tcp_cfg = transportConfig;
    tcp_cfg.port = 5080;
    
    GSReturnNoIfFails(pjsua_transport_create(PJSIP_TRANSPORT_TCP, &tcp_cfg, &_transportId));
    
    pjsua_transport_config tcp6_cfg;
    tcp6_cfg = transportConfig;
    tcp6_cfg.port = 5090;
    
    GSReturnNoIfFails(pjsua_transport_create(PJSIP_TRANSPORT_TCP6, &tcp6_cfg, &_transportId));
    
    
    [self setStatus:GSUserAgentStateConfigured];

    // configure account
    _account = [[GSAccount alloc] init];
    return [_account configure:_config.account];
}

- (BOOL)start {
    GSReturnNoIfFails(pjsua_start());
    [self setStatus:GSUserAgentStateStarted];
    return YES;
}

- (BOOL)reset {
    [_account disconnect];

    // needs to nil account before pjsua_destroy so pjsua_acc_del succeeds.
    _transportId = PJSUA_INVALID_ID;
    _account = nil;
    _config = nil;
    NSLog(@"Destroying...");
    GSReturnNoIfFails(pjsua_destroy());
    [self setStatus:GSUserAgentStateDestroyed];
    return YES;
}

- (void)keepAlive {
    /* Register this thread if not yet */
    if (!pj_thread_is_registered()) {
        static pj_thread_desc   thread_desc;
        static pj_thread_t     *thread;
        pj_thread_register("mainthread", thread_desc, &thread);
    }
    
    /* Simply sleep for 5s, give the time for library to send transport
     * keepalive packet, and wait for server response if any. Don't sleep
     * too short, to avoid too many wakeups, because when there is any
     * response from server, app will be woken up again (see also #1482).
     */
    pj_thread_sleep(5000);
}

- (NSArray *)arrayOfAvailableCodecs {
    GSAssert(!!_config, @"Gossip: User agent not configured.");
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    unsigned int count = 255;
    pjsua_codec_info codecs[count];
    GSReturnNilIfFails(pjsua_enum_codecs(codecs, &count));
    
    for (int i = 0; i < count; i++) {
        pjsua_codec_info pjCodec = codecs[i];
        
        GSCodecInfo *codec = [GSCodecInfo alloc];
        codec = [codec initWithCodecInfo:&pjCodec];
        [arr addObject:codec];
    }
    
    return [NSArray arrayWithArray:arr];
}

@end
