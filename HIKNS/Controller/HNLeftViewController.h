//
//  HNLeftViewController.h
//  HIKNS
//
//  Created by cysu on 16/1/20.
//  Copyright © 2016年 cysu1077.ns. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HNLeftControllerDelegate <NSObject>
@optional

- (void)shouldRequestDataWithKind:(RequestKind)kind;

@end

@interface HNLeftViewController : UIViewController

@property (nonatomic, weak) id<HNLeftControllerDelegate> delegate;

@end
