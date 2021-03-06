//
//  HNCommentTitleCell.m
//  HIKNS
//
//  Created by cysu on 16/1/23.
//  Copyright © 2016年 cysu1077.ns. All rights reserved.
//

#import "HNCommentTitleCell.h"
#import <NSDate+TimeAgo.h>

@implementation HNCommentTitleCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.backgroundColor = kMainBackgroundColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureUIWithModel:(HNStoryModel *)story
{
    NSLog(@"haha");
    self.topic.text = story.type;
    self.titleLabel.text = story.title;
    
    
    NSDate *storyDate = [NSDate dateWithTimeIntervalSince1970:story.time.doubleValue];
    NSString *dateDescribe = [storyDate dateTimeAgo];
    NSString *timeAndAuthor = [NSString stringWithFormat:@"By %@ at %@, %@ points", story.author, dateDescribe, story.score];
    self.timeAndAuthor.text = timeAndAuthor;
    if (IsStringEmpty(story.content)) {
        [self.content removeFromSuperview];
        [self layoutIfNeeded];
    } else {
        self.content.enabledTextCheckingTypes = NSTextCheckingTypeLink;
        NSMutableDictionary *mutableActiveLinkAttributes = [NSMutableDictionary dictionary];
        [mutableActiveLinkAttributes setObject:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
        [mutableActiveLinkAttributes setObject:[UIColor greenColor] forKey:(NSString *)kCTForegroundColorAttributeName];
        self.content.activeLinkAttributes = [NSDictionary dictionaryWithDictionary:mutableActiveLinkAttributes];
        
        NSDictionary *options = @{
                                  NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType
                                  };
        NSDictionary *attributeDict = @{
                                        NSForegroundColorAttributeName : kLightTextColor,
                                        NSFontAttributeName : [UIFont systemFontOfSize:16]
                                        };
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[story.content dataUsingEncoding:NSUnicodeStringEncoding] options:options documentAttributes:nil error:nil];
        [attributedString addAttributes:attributeDict range:NSMakeRange(0, attributedString.length)];
        self.content.attributedText = attributedString;
        
        NSDataDetector* detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
        NSArray* matches = [detector matchesInString:attributedString.string options:0 range:NSMakeRange(0, [attributedString.string length])];
        if (matches.count > 0) {
            for (NSTextCheckingResult *result in matches) {
                [self.content addLinkWithTextCheckingResult:result attributes:@{
                                                                                NSForegroundColorAttributeName : kLightTextColor,
                                                                                NSFontAttributeName : [UIFont systemFontOfSize:16]
                                                                                }];
            }
        }
    }
}

@end
