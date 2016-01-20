//
//  HNRequestManager.h
//  HIKNS
//
//  Created by cysu on 16/1/20.
//  Copyright © 2016年 cysu1077.ns. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HNStoryModel.h"

typedef void(^RequestHanlder)(id object, BOOL state);

typedef NS_ENUM (NSInteger, requestState) {
    requestError = 0,
    requestSuccess = 1
};

@interface HNRequestManager : NSObject

+ (instancetype)manager;

- (void)getNewStoryIDs:(RequestHanlder)complete;

@end
