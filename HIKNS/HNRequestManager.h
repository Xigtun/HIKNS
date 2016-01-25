//
//  HNRequestManager.h
//  HIKNS
//
//  Created by cysu on 16/1/20.
//  Copyright © 2016年 cysu1077.ns. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HNStoryModel.h"

@interface HNRequestManager : NSObject

+ (instancetype)manager;

- (void)getNewStoryIDsWithKind:(RequestKind)kind hanlder:(RequestHanlder)complete;

- (void)getStoryDataByIDs:(NSArray *)storyIDs hanlder:(RequestHanlder)complete;

- (void)getStoryDataByIDs:(NSArray *)storyIDs kind:(RequestKind)kind hanlder:(RequestHanlder)complete;

@end
