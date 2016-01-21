//
//  AppDelegate.h
//  HIKNS
//
//  Created by cysu on 16/1/20.
//  Copyright © 2016年 cysu1077.ns. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IIViewDeckController;
@class HNMainTableViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UIViewController *centerController;
@property (strong, nonatomic) UIViewController *leftController;

- (IIViewDeckController*)generateControllerStack;

@end

