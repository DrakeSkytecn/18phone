////
////  darwin_dev.h
////  18phone
////
////  Created by 戴全艺 on 16/8/31.
////  Copyright © 2016年 Kratos. All rights reserved.
////
//
//#ifndef darwin_dev_h
//#define darwin_dev_h
//
//#import "util.h"
//#import "../pjsip/src/pjmedia/include/pjmedia-videodev/videodev_imp.h"
//#import <pj/assert.h>
//#import <pj/log.h>
//#import <pj/os.h>
//#import <pj/config.h>
//#import "../pjsip/src/pjmedia/src/pjmedia-videodev/util.h"
//
//PJ_DECL(pjmedia_vid_dev_factory*) pjmedia_darwin_factory(pj_pool_factory *pf);
//
///* Prototypes */
//PJ_DECL(pj_status_t) darwin_factory_init(pjmedia_vid_dev_factory *f);
//PJ_DECL(pj_status_t) darwin_factory_destroy(pjmedia_vid_dev_factory *f);
//PJ_DECL(pj_status_t) darwin_factory_refresh(pjmedia_vid_dev_factory *f);
//PJ_DECL(unsigned) darwin_factory_get_dev_count(pjmedia_vid_dev_factory *f);
//PJ_DECL(pj_status_t) darwin_factory_get_dev_info(pjmedia_vid_dev_factory *f,
//                                               unsigned index,
//                                               pjmedia_vid_dev_info *info);
//PJ_DECL(pj_status_t) darwin_factory_default_param(pj_pool_t *pool,
//                                                pjmedia_vid_dev_factory *f,
//                                                unsigned index,
//                                                pjmedia_vid_dev_param *param);
//PJ_DECL(pj_status_t) darwin_factory_create_stream(
//                                                pjmedia_vid_dev_factory *f,
//                                                pjmedia_vid_dev_param *param,
//                                                const pjmedia_vid_dev_cb *cb,
//                                                void *user_data,
//                                                pjmedia_vid_dev_stream **p_vid_strm);
//
//PJ_DECL(pj_status_t) darwin_stream_get_param(pjmedia_vid_dev_stream *strm,
//                                           pjmedia_vid_dev_param *param);
//PJ_DECL(pj_status_t) darwin_stream_get_cap(pjmedia_vid_dev_stream *strm,
//                                         pjmedia_vid_dev_cap cap,
//                                         void *value);
//PJ_DECL(pj_status_t) darwin_stream_set_cap(pjmedia_vid_dev_stream *strm,
//                                         pjmedia_vid_dev_cap cap,
//                                         const void *value);
//PJ_DECL(pj_status_t) darwin_stream_start(pjmedia_vid_dev_stream *strm);
//PJ_DECL(pj_status_t) darwin_stream_get_frame(pjmedia_vid_dev_stream *strm,
//                                           pjmedia_frame *frame);
//PJ_DECL(pj_status_t) darwin_stream_put_frame(pjmedia_vid_dev_stream *strm,
//                                           const pjmedia_frame *frame);
//PJ_DECL(pj_status_t) darwin_stream_stop(pjmedia_vid_dev_stream *strm);
//PJ_DECL(pj_status_t) darwin_stream_destroy(pjmedia_vid_dev_stream *strm);
//
//
//
//#endif /* darwin_dev_h */
