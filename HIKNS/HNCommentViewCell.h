//
//  HNCommentViewCell.h
//  HIKNS
//
//  Created by cysu on 16/1/22.
//  Copyright © 2016年 cysu1077.ns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNStoryModel.h"

@interface HNCommentViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *authorName;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCount;

@property (weak, nonatomic) IBOutlet UILabel *content;



- (void)configureUI:(HNStoryModel *)story index:(NSInteger)index;

@end
