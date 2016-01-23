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
        self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
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

#pragma mark - Public
- (NSMutableArray *)getStoryIDs
{
    NSMutableArray *storyIDs = [NSMutableArray array];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = @"select id from stories order by id desc";
        FMResultSet *result = [db executeQuery:sql];
        while ([result next]) {
            NSInteger storyID = [result intForColumn:@"id"];
            [storyIDs addObject:[NSNumber numberWithInteger:storyID]];
        }
    }];
    return storyIDs;
}

- (HNStoryModel *)getStoryByID:(NSNumber *)storyID
{
    __block HNStoryModel *story = [HNStoryModel new];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = @"select * from stories where id = ?;";
        FMResultSet *result = [db executeQuery:sql, storyID];
        while ([result next]) {
            story = [MTLFMDBAdapter modelOfClass:[HNStoryModel class] fromFMResultSet:result error:nil];
        }
    }];
    
    return story;
}

- (void)insertID:(NSArray *)storyIDs kind:(RequestKind)kind
{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        for (NSNumber *storyID in storyIDs) {
            NSString *sql = @"insert stories (id) values (?)";
            [db executeUpdate:sql, storyID];
        }
    }];
}

- (void)insertStory:(HNStoryModel *)story
{
    __block BOOL result = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"PRAGMA foreign_keys=ON;"];
        NSString *sqlInsert = @"insert into stories (id, title, type, author, time, url, score, comment_count, kids) values (?, ?, ?, ?, ?, ?, ?, ?, ?);";
        NSString *kids = [story.kids componentsJoinedByString:@","];
        result = [db executeUpdate:sqlInsert, story.storyID, story.title, story.type, story.author, story.time, story.originPath, story.score, story.descendants, kids];
        NSLog(@"%hhd", result);
    }];
}

@end
