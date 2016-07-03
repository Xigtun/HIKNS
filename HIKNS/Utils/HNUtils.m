//
//  HNUtils.m
//  HIKNS
//
//  Created by cysu on 7/3/16.
//  Copyright © 2016 cysu1077.ns. All rights reserved.
//

#import "HNUtils.h"

@implementation HNUtils

+ (NSString *)jsonObjectToString:(id)jsonObject
{
    NSError *err;
    NSData *jsonData = [NSJSONSerialization  dataWithJSONObject:jsonObject options:0 error:&err];
    NSString *myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return myString;
}

+ (id)stringToJsonobject:(NSString *)jsonstr
{
    NSData *data = [jsonstr dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    return json;
}

@end
