//
//  HNRequestManager.m
//  HIKNS
//
//  Created by cysu on 16/1/20.
//  Copyright © 2016年 cysu1077.ns. All rights reserved.
//

#import "HNRequestManager.h"
#import <Firebase/Firebase.h>
#import "HNDataBaseManager.h"

@implementation HNRequestManager

static NSString *const kTopStories = @"https://hacker-news.firebaseio.com/v0/topstories";

static NSString *const kAskStories = @"https://hacker-news.firebaseio.com/v0/askstories";

static NSString *const kShowStories = @"https://hacker-news.firebaseio.com/v0/showstories";

static NSString *const kJobStories = @"https://hacker-news.firebaseio.com/v0/jobstories";

static NSString *const kBestStories = @"https://hacker-news.firebaseio.com/v0/beststories";

+ (instancetype)manager
{
    static HNRequestManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[HNRequestManager alloc] init];
        }
    });
    return manager;
}

- (void)getNewStoryIDsWithKind:(RequestKind)kind hanlder:(RequestHanlder)complete
{
    NSString *requestPath;
    switch (kind) {
        case RequestKindNews:
            requestPath = kTopStories;
            break;
        case RequestKindAsk:
            requestPath = kAskStories;
            break;
        case RequestKindShow:
            requestPath = kShowStories;
            break;
        case RequestKindJobs:
            requestPath = kJobStories;
            break;
        case RequestKindBest:
            requestPath = kBestStories;
            break;
    }
    
    Firebase *storiesIdEvent = [[Firebase alloc] initWithUrl:requestPath];
    @weakify(self);
    [storiesIdEvent observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        @strongify(self);
        NSArray *storyIDs = [snapshot.value mutableCopy];
        NSLog(@"%@", storyIDs);
        [self getStoryDataByIDs:storyIDs hanlder:complete];
    } withCancelBlock:^(NSError *error) {
        complete(error, requestError);
    }];
}

- (void)getStoryDataByIDs:(NSArray *)storyIDs hanlder:(RequestHanlder)complete
{
    NSMutableArray *storyModels = [NSMutableArray array];
    for (NSString *itemNumber in storyIDs) {
        NSString *urlString = [NSString stringWithFormat:@"https://hacker-news.firebaseio.com/v0/item/%@",itemNumber];
        Firebase *storyDescriptionRef = [[Firebase alloc] initWithUrl:urlString];
        [storyDescriptionRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            NSDictionary *responseDictionary = snapshot.value;
            HNStoryModel *story = [MTLJSONAdapter modelOfClass:[HNStoryModel class] fromJSONDictionary:responseDictionary error:nil];
            [[HNDataBaseManager manager] insertStory:story];
            
            [storyModels addObject:story];
            if (storyModels.count == storyIDs.count) {
                complete(storyModels, requestSuccess);
            }
        } withCancelBlock:^(NSError *error) {
            [storyModels addObject:error];
            if (storyModels.count == storyIDs.count) {
                complete(storyModels, requestSuccess);
            }
        }];
    }
}

- (void)getStoryDataOfItem:(NSNumber *)itemNumber {
    
    NSString *urlString = [NSString stringWithFormat:@"https://hacker-news.firebaseio.com/v0/item/%@",itemNumber];
    Firebase *storyDescriptionRef = [[Firebase alloc] initWithUrl:urlString];
    
    [storyDescriptionRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        NSDictionary *responseDictionary = snapshot.value;
        NSLog(@"%@", responseDictionary);
        
    } withCancelBlock:^(NSError *error) {
        
    }];
}

@end
