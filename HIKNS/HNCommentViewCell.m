//
//  HNCommentViewCell.m
//  HIKNS
//
//  Created by cysu on 16/1/22.
//  Copyright © 2016年 cysu1077.ns. All rights reserved.
//

#import "HNCommentViewCell.h"
#import <NSDate+TimeAgo.h>

@implementation HNCommentViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureUI:(HNStoryModel *)story index:(NSInteger)index
{
    NSDate *storyDate = [NSDate dateWithTimeIntervalSince1970:story.time.doubleValue];
    NSString *dateDescribe = [storyDate dateTimeAgo];
    self.timeLabel.text = dateDescribe;
    
    self.authorName.text = story.author;
    self.content.text = story.content;
    self.commentCount.text = [NSString stringWithFormat:@"%ld", (long)index];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.timeLabel.text = @"";
    self.authorName.text = @"";
    self.content.text = @"";
    self.commentCount.text = @"";
}

@end
