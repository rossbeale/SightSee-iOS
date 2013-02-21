//
//  SSAppDelegate.m
//  SightSee
//
//  Created by Ross Beale on 18/02/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import "SSAppDelegate.h"
#import "SSDataManager.h"

@implementation SSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self _setupAppearance];
    
    [[SSDataManager sharedInstance] fetchData];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self cleanUpCoreData];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self cleanUpCoreData];
}

#pragma mark - Core Data management

- (void)cleanUpCoreData
{
    if ([[CoreDataManager instance] saveContext]) {
        DLog(@"Core Data saved.");
    } else {
        DLog(@"Core Data NOT saved.");
    }
}

#pragma mark - UI

- (void)_setupAppearance
{
    [self _setupNavigationBarAppearance];
    [self _setupTabBarAppearance];
}

- (void)_setupNavigationBarAppearance
{
    // Customise navigation bar
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                    UITextAttributeFont : [UIFont fontWithName:@"PTSans-Bold" size:21.0]
                                    }];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{
                                    UITextAttributeFont : [UIFont fontWithName:@"PTSans-Bold" size:12.0]
                                    } forState:UIControlStateNormal];
    
    [[UIBarButtonItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, 1) forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(1, 1) forBarMetrics:UIBarMetricsDefault];
}

- (void)_setupTabBarAppearance
{
    // Customise tab bar items
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                    UITextAttributeFont : [UIFont fontWithName:@"PTSans-Bold" size:10]
                                    } forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -1)];
}

@end
