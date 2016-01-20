//
//  HNMainTableViewCell.m
//  HIKNS
//
//  Created by cysu on 16/1/20.
//  Copyright © 2016年 cysu1077.ns. All rights reserved.
//

#import "HNMainTableViewCell.h"

@implementation HNMainTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)configureUI:(HNStoryModel *)story
{
    self.type.text = story.type;
    self.author.text = story.author;
    self.title.text = story.title;
    self.commentCount.text = story.descendants.stringValue;
    self.originPath.text = story.originPath;
    
    self.timeAndPoint.text = story.time.stringValue;
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
