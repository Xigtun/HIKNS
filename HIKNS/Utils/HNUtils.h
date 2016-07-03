//
//  HNUtils.h
//  HIKNS
//
//  Created by cysu on 7/3/16.
//  Copyright © 2016 cysu1077.ns. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNUtils : NSObject

+ (NSString *)jsonObjectToString:(id)jsonObject;

+ (id)stringToJsonobject:(NSString *)jsonstr;

@end
