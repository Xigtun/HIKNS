//
//  HNDataBaseManager.m
//  HIKNS
//
//  Created by cysu on 16/1/20.
//  Copyright © 2016年 cysu1077.ns. All rights reserved.
//

#import "HNDataBaseManager.h"
#import <FMDB/FMDB.h>

@implementation HNDataBaseManager

+ (instancetype)manager
{
    static HNDataBaseManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[HNDataBaseManager alloc] init];
        }
    });
    return manager;
}

- (void)prepareDataBase
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
        NSString *dbPath = [docPath stringByAppendingPathComponent:@"HN.db"];
        
        if (![fileManager fileExistsAtPath:dbPath]) {
            NSURL *prototypeDBURL = [[NSBundle mainBundle] URLForResource:@"HN" withExtension:@"db"];
            NSError *error = nil;
            [fileManager copyItemAtURL:prototypeDBURL toURL:[NSURL fileURLWithPath:dbPath] error:&error];
            if (error) {
                NSLog(@"%@", error);
            }
        }
    });
}



@end
