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
        NSError *error = nil;
        BOOL success = [[NSURL fileURLWithPath:dbPath] setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
        if(!success){
            NSLog(@"Error excluding %@ from backup %@", [dbPath lastPathComponent], error);
        }
        self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    });
}

#pragma mark - Public
- (NSMutableArray *)getStoryIDs
{
    NSMutableArray *storyIDs = [NSMutableArray array];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = @"select story_id from story_news order by id desc";
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
        NSString *sql = @"select * from story_news where story_id = ?;";
        FMResultSet *result = [db executeQuery:sql, storyID];
        while ([result next]) {
            story = [MTLFMDBAdapter modelOfClass:[HNStoryModel class] fromFMResultSet:result error:nil];
        }
    }];
    
    return story;
}

- (NSMutableArray *)getStoriesWithKind:(RequestKind)kind
{
    NSMutableArray *stories = [NSMutableArray array];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = [self getTableName:kind];
        NSString *sql = [NSString stringWithFormat:@"select * from %@", tableName];
        FMResultSet *result = [db executeQuery:sql];
        while ([result next]) {
            HNStoryModel *story = [MTLFMDBAdapter modelOfClass:[HNStoryModel class] fromFMResultSet:result error:nil];
            if (story.title) {
                [stories addObject:story];
            }
        }
    }];
    
    return stories;
}

- (void)insertID:(NSArray *)storyIDs kind:(RequestKind)kind
{
    NSArray *tempArray = [storyIDs copy];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = [self getTableName:kind];
        for (NSNumber *storyID in tempArray) {
            NSString *sql = [NSString stringWithFormat:@"insert into %@ (story_id) values (?)", tableName];
            [db executeUpdate:sql, storyID];
        }
    }];
}

- (void)insertStory:(HNStoryModel *)story kind:(RequestKind)kind
{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = [self getTableName:kind];
        NSString *sql = [NSString stringWithFormat:@"update %@ set title=?, type=?, author=?, time=?, url=?, score=?, comment_count=?, kids=? where story_id=?", tableName];
        NSString *kids = [story.kids componentsJoinedByString:@","];
        BOOL result = [db executeUpdate:sql, story.title, story.type, story.author, story.time, story.originPath, story.score, story.descendants, kids, story.storyID];
        NSLog(result ? @"YES" : @"NO");
    }];
}

- (void)deleteAllData:(RequestKind)kind
{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = [self getTableName:kind];
        NSString *sql = [NSString stringWithFormat:@"delete from %@", tableName];
        BOOL result = [db executeUpdate:sql];
        NSLog(result ? @"YES" : @"NO");
    }];
}

#pragma mark - Private
- (NSString *)getTableName:(RequestKind)kind
{
    NSString *tableName;
    switch (kind) {
        case RequestKindNews:
            tableName = @"story_news";
            break;
        case RequestKindAsk:
            tableName = @"story_ask";
            break;
        case RequestKindShow:
            tableName = @"story_show";
            break;
        case RequestKindJobs:
            tableName = @"story_jobs";
            break;
        case RequestKindBest:
            tableName = @"story_best";
            break;
    }
    return tableName;
}

@end
