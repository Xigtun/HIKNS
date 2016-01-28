//
//  HNCommentViewCell.m
//  HIKNS
//
//  Created by cysu on 16/1/22.
//  Copyright © 2016年 cysu1077.ns. All rights reserved.
//

#import "HNCommentViewCell.h"
#import <NSDate+TimeAgo.h>
#import "UIColor+Hex.h"

@implementation HNCommentViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.commentCount.layer.cornerRadius = CGRectGetHeight(self.commentCount.frame) * 0.5;
    self.commentCount.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureUI:(HNStoryModel *)story index:(NSInteger)index
{
    if (!IsStringEmpty(story.author)) {
        NSDate *storyDate = [NSDate dateWithTimeIntervalSince1970:story.time.doubleValue];
        NSString *dateDescribe = [storyDate dateTimeAgo];
        self.timeLabel.text = dateDescribe;
        
        self.authorName.text = story.author;
        self.commentCount.text = [NSString stringWithFormat:@"%ld", (long)index+1];
        
        NSDictionary *options = @{
                                  NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType
                                  };
        NSDictionary *attributeDict = @{
                                        NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#7f7e7b"],
                                        NSFontAttributeName : [UIFont systemFontOfSize:16]
                                        };
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[story.content dataUsingEncoding:NSUTF8StringEncoding] options:options documentAttributes:nil error:nil];
        [attributedString addAttributes:attributeDict range:NSMakeRange(0, attributedString.length)];
        
        self.content.attributedText = attributedString;
    } else {
        self.timeLabel.text = @"3 hours ago";
        self.authorName.text = @"Weithl";
        self.commentCount.text = [NSString stringWithFormat:@"%ld", (long)index+1];
        self.content.text = @"hahhahaha";
    }
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
