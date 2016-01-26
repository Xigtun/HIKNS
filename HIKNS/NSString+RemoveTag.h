//
//  NSString+RemoveTag.h
//  HIKNS
//
//  Created by cysu on 16/1/20.
//  Copyright © 2016年 cysu1077.ns. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RemoveTag)

- (NSString *)stringByRemovingTag:(NSString *)tag;
- (NSString *)stringByRemovingOpeningTag:(NSString *)tag withClosingTag:(NSString *)closingTag;

@end
