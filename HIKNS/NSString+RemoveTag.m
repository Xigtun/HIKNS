//
//  NSString+RemoveTag.h
//  HIKNS
//
//  Created by cysu on 16/1/20.
//  Copyright © 2016年 cysu1077.ns. All rights reserved.
//

#import "NSString+RemoveTag.h"

@implementation NSString (RemoveTag)

- (NSString *)stringByRemovingTag:(NSString *)tag{
    NSString *closingTag = [tag stringByReplacingOccurrencesOfString:@"<" withString:@"</"];
    NSString *string = [self stringByReplacingOccurrencesOfString:tag withString:@""];
    string = [string stringByReplacingOccurrencesOfString:closingTag withString:@""];
    return string;
}

- (NSString *)stringByRemovingOpeningTag:(NSString *)tag withClosingTag:(NSString *)closingTag{
    NSString *string = [self stringByReplacingOccurrencesOfString:tag withString:@""];
    string = [string stringByReplacingOccurrencesOfString:closingTag withString:@""];
    return string;
}

@end
