//
//  AppDelegate.m
//  HIKNS
//
//  Created by cysu on 16/1/20.
//  Copyright © 2016年 cysu1077.ns. All rights reserved.
//

#import "AppDelegate.h"

#import <Firebase/Firebase.h>
#import <IIViewDeckController.h>

#import <QuartzCore/QuartzCore.h>

#import "HNDataBaseManager.h"
#import "HNCenterViewController.h"
#import "HNLeftViewController.h"

#import "GTScrollNavigationBar.h"
#import "HNLaunchService.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    IIViewDeckController* deckController = [self generateControllerStack];
    self.leftController = deckController.leftController;
    self.centerController = deckController.centerController;
    self.window.rootViewController = deckController;
    [self.window makeKeyAndVisible];
    
    [HNLaunchService configureEnvironment];
    
    return YES;
}

- (IIViewDeckController*)generateControllerStack {
    HNLeftViewController* leftController = [[HNLeftViewController alloc] init];
    UIViewController *centerController = [[HNCenterViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithNavigationBarClass:[GTScrollNavigationBar class]
                                                  toolbarClass:nil];
    [navController setViewControllers:@[centerController] animated:NO];
    IIViewDeckController* deckController =  [[IIViewDeckController alloc] initWithCenterViewController:navController
                                                                                    leftViewController:leftController
                                                                                   rightViewController:nil];
    deckController.shadowEnabled = NO;
    deckController.sizeMode = IIViewDeckLedgeSizeMode;
    [deckController disablePanOverViewsOfClass:NSClassFromString(@"_UITableViewHeaderFooterContentView")];
    return deckController;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [Firebase goOffline];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [Firebase goOnline];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
