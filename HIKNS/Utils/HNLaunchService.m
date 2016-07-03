//
//  HNLaunchService.m
//  HIKNS
//
//  Created by cysu on 7/3/16.
//  Copyright © 2016 cysu1077.ns. All rights reserved.
//

#import "HNLaunchService.h"
#import <MAThemeKit/MAThemeKit.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "HNDataBaseManager.h"

@implementation HNLaunchService

+ (void)configureEnvironment
{
    NSURLCache *urlCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:urlCache];
    
    [[Fabric sharedSDK] setDebug: YES];
    [Fabric with:@[[Crashlytics class]]];
    
    [[HNDataBaseManager manager] prepareDataBase];
    
    [MAThemeKit setupThemeWithPrimaryColor:kMainBackgroundColor secondaryColor:kMainTextColor fontName:@"HelveticaNeue" lightStatusBar:YES];
    [MAThemeKit customizeActivityIndicatorColor:kMainTextColor];
    [MAThemeKit customizeToolbarTintColor:kMainTextColor];
    [[UIButton appearance] setTitleColor:kLightTextColor forState:UIControlStateNormal];
    [[UINavigationBar appearance] setBarTintColor:kMainBackgroundColor];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
}

@end
