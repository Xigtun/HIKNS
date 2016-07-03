//
//  HNMainTableViewCell.h
//  HIKNS
//
//  Created by cysu on 16/1/20.
//  Copyright © 2016年 cysu1077.ns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNStoryModel.h"

@interface HNMainTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *author;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *commentCount;
@property (weak, nonatomic) IBOutlet UILabel *timeAndPoint;
@property (weak, nonatomic) IBOutlet UILabel *originPath;


- (void)configureUI:(HNStoryModel *)story;

@end
