//
//  HNMainTableViewCell.m
//  HIKNS
//
//  Created by cysu on 16/1/20.
//  Copyright © 2016年 cysu1077.ns. All rights reserved.
//

#import "HNMainTableViewCell.h"
#import <NSDate+TimeAgo.h>
#import <UIView+Positioning.h>
#import "UIColor+Hex.h"

@implementation HNMainTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.type.layer.cornerRadius = 6.0;
    self.type.layer.masksToBounds = YES;
    
    self.commentCount.layer.cornerRadius = CGRectGetHeight(self.commentCount.frame) * 0.5;
    self.commentCount.layer.masksToBounds = YES;
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#f2f1ed"];
}

- (void)configureUI:(HNStoryModel *)story
{
    if (story) {
        self.type.text = story.type;
        self.author.text = story.author;
        self.title.text = story.title;
        if (IsStringEmpty(story.originPath)) {
            self.timeAndPoint.centerY += 24;
        } else {
            self.originPath.text = [self extractDomain:story.originPath];
        }
        if ([story.type isEqualToString:@"job"]) {
            self.commentCount.hidden = YES;
        } else {
            self.commentCount.text = story.descendants.stringValue;
        }
        
        NSDate *storyDate = [NSDate dateWithTimeIntervalSince1970:story.time.doubleValue];
        NSString *dateDescribe = [storyDate dateTimeAgo];
        
        NSString *showString = [NSString stringWithFormat:@"%@   %@ points", dateDescribe, story.score];
        self.timeAndPoint.text = showString;
        
        [self layoutIfNeeded];
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
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#f2f1ed"];

    self.commentCount.hidden = NO;
    self.type.text = @"";
    self.author.text = @"";
    self.title.text = @"";
    self.commentCount.text = @"";
    self.originPath.text = @"";
    self.timeAndPoint.text = @"";
}

- (NSString *)extractDomain:(NSString *)fullPath
{
    
    // Convert the string to an NSURL to take advantage of NSURL's parsing abilities.
    NSURL * url = [NSURL URLWithString:fullPath];
    
    // Get the host, e.g. "secure.twitter.com"
    NSString * host = [url host];
//    host = [host stringByReplacingOccurrencesOfString:@"www." withString:@""];
    return host;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
