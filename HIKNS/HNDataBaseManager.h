//
//  HNDataBaseManager.h
//  HIKNS
//
//  Created by cysu on 16/1/20.
//  Copyright © 2016年 cysu1077.ns. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabaseQueue;
@interface HNDataBaseManager : NSObject

@property (nonatomic, strong) FMDatabaseQueue *databaseQueue;

+ (instancetype)manager;

- (void)prepareDataBase;

@end
