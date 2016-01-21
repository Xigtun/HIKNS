//
//  HNMainTableViewCell.m
//  HIKNS
//
//  Created by cysu on 16/1/20.
//  Copyright © 2016年 cysu1077.ns. All rights reserved.
//

#import "HNMainTableViewCell.h"
#import <NSDate+TimeAgo.h>

@implementation HNMainTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.type.layer.cornerRadius = 6.0;
    self.type.layer.masksToBounds = YES;
    
    self.commentCount.layer.cornerRadius = CGRectGetHeight(self.commentCount.frame) * 0.5;
    self.commentCount.layer.masksToBounds = YES;
}

- (void)configureUI:(HNStoryModel *)story
{
    if (story) {
        self.type.text = story.type;
        self.author.text = story.author;
        self.title.text = story.title;
        self.commentCount.text = story.descendants.stringValue;
        self.originPath.text = story.originPath;
        
        NSDate *storyDate = [NSDate dateWithTimeIntervalSince1970:story.time.doubleValue];
        NSString *dateDescribe = [storyDate dateTimeAgo];
        
        NSString *showString = [NSString stringWithFormat:@"%@   %@ score", dateDescribe, story.score];
        self.timeAndPoint.text = showString;
    } else {
        self.type.text = @"";
        self.author.text = @"";
        self.title.text = @"";
        self.commentCount.text = @"";
        self.originPath.text = @"";
        self.timeAndPoint.text = @"";
    }
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.type.text = @"";
    self.author.text = @"";
    self.title.text = @"";
    self.commentCount.text = @"";
    self.originPath.text = @"";
    self.timeAndPoint.text = @"";
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
