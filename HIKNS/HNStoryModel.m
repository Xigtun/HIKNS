//
//  HNStoryModel.m
//  HIKNS
//
//  Created by cysu on 16/1/20.
//  Copyright © 2016年 cysu1077.ns. All rights reserved.
//

#import "HNStoryModel.h"

@implementation HNStoryModel

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

@end
