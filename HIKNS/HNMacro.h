//
//  HNMacro.h
//  HIKNS
//
//  Created by cysu on 16/1/22.
//  Copyright © 2016年 cysu1077.ns. All rights reserved.
//

#ifndef HNMacro_h
#define HNMacro_h


#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif


//字符串是否为空
#define IsStringEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref)isEqualToString:@""]))
//数组是否为空
#define IsArrayEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref) count] == 0))

typedef void(^RequestHanlder)(id object, BOOL state);

typedef NS_ENUM (NSInteger, requestState){
    requestError = 0,
    requestSuccess = 1,
};

typedef NS_ENUM (NSInteger, RequestKind) {
    RequestKindNews,
    RequestKindAsk,
    RequestKindShow,
    RequestKindJobs,
    RequestKindBest,
};

#endif /* HNMacro_h */
