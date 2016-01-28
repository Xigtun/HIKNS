//
//  HNCommentTitleCell.h
//  HIKNS
//
//  Created by cysu on 16/1/23.
//  Copyright © 2016年 cysu1077.ns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNStoryModel.h"
#import "TTTAttributedLabel.h"

@interface HNCommentTitleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *topic;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeAndAuthor;

@property (weak, nonatomic) IBOutlet TTTAttributedLabel *content;

- (void)configureUIWithModel:(HNStoryModel *)story;

@end
