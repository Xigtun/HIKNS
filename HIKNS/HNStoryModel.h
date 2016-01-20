//
//  HNStoryModel.h
//  HIKNS
//
//  Created by cysu on 16/1/20.
//  Copyright © 2016年 cysu1077.ns. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HNStoryModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *storyID;
@property (nonatomic, strong) NSNumber *time;
@property (nonatomic, strong) NSNumber *score;
@property (nonatomic, strong) NSNumber *descendants;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *originPath;//url
@property (nonatomic, copy) NSString *author;

@property (nonatomic, strong) NSArray *kids;

@end
