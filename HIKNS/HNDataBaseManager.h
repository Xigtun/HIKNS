//
//  HNDataBaseManager.h
//  HIKNS
//
//  Created by cysu on 16/1/20.
//  Copyright © 2016年 cysu1077.ns. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HNStoryModel.h"

@class FMDatabaseQueue;

@interface HNDataBaseManager : NSObject

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

+ (instancetype)manager;

- (void)prepareDataBase;

#pragma mark - Public

- (NSMutableArray *)getStoryIDs;

- (HNStoryModel *)getStoryByID:(NSNumber *)storyID;

- (void)insertID:(NSArray *)storyIDs kind:(RequestKind)kind;

- (void)insertStory:(HNStoryModel *)story;

@end
