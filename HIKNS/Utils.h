//
//  Utils.h
//  HIKNS
//
//  Created by cysu on 16/1/20.
//  Copyright © 2016年 cysu1077.ns. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (NSString *)makeThisPieceOfHTMLBeautiful: (NSString *)htmlString withFont:(NSString *)fontName ofSize:(int)size;
+ (NSAttributedString *)convertHTMLToAttributedString:(NSString *)string;
+ (NSString *)convertHTMLToPlainString:(NSString *)string;
@end
