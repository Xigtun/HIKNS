//
//  HNStoryModel.m
//  HIKNS
//
//  Created by cysu on 16/1/20.
//  Copyright © 2016年 cysu1077.ns. All rights reserved.
//

#import "HNStoryModel.h"

@implementation HNStoryModel

#pragma mark - Network
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"storyID" : @"id",
             @"kids" : @"kids",
             @"originPath" : @"url",
             @"score" : @"score",
             @"descendants" : @"descendants",
             @"author" : @"by",
             @"type" : @"type",
             @"time" : @"time",
             @"title" : @"title",
             @"content" : @"text",
             @"parent" : @"parent",
             };
}

- (void)setNilValueForKey:(NSString *)key
{
    [self setValue:@"" forKey:key];
}

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *modifiedDictionaryValue = [[super dictionaryValue] mutableCopy];
    
    for (NSString *originalKey in [super dictionaryValue]) {
        if ([self valueForKey:originalKey] == nil) {
            [modifiedDictionaryValue removeObjectForKey:originalKey];
        }
    }
    
    return [modifiedDictionaryValue copy];
}


#pragma mark - Database
+ (NSDictionary *)FMDBColumnsByPropertyKey
{
    return @{
             @"storyID" : @"story_id",
             @"kidsString" : @"kids",
             @"originPath" : @"url",
             @"score" : @"score",
             @"descendants" : @"comment_count",
             @"author" : @"author",
             @"type" : @"type",
             @"time" : @"time",
             @"title" : @"title",
             };
}

+ (NSArray *)FMDBPrimaryKeys
{
    return @[@"story_id", @"type"];
}

+ (NSString *)FMDBTableName {
    return @"stories";
}

@end
