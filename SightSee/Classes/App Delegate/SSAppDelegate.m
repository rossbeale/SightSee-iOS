//
//  SSAppDelegate.m
//  SightSee
//
//  Created by Ross Beale on 18/02/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import "SSAppDelegate.h"
#import "SSDataManager.h"
#import "SSLocationDetailViewController.h"

#if RUN_KIF_TESTS
#import "TestController.h"
#endif

@implementation SSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self _setupAppearance];
    
    // are we launching from a notification?
    if (launchOptions) {
        UILocalNotification *notification;
        if ((notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey])) {
            [self processLocalNotification:notification withAlert:NO];
            [self clearNotifications];
            return YES;
        }
    }
    
    [[SSDataManager sharedInstance] fetchData];
    
    #if RUN_KIF_TESTS
        [[TestController sharedInstance] startTestingWithCompletionBlock:^{
            // Exit after the tests complete so that CI knows we're done
            exit([[TestController sharedInstance] failureCount]);
        }];
    #endif
    
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

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    DLog(@"Incoming notification in running app");
    [self processLocalNotification:notification withAlert:YES];
    [self clearNotifications];
}

#pragma mark - Notification handling

- (void)processLocalNotification:(UILocalNotification *)notification withAlert:(BOOL)showAlert
{
    NSDictionary *userInfo = notification.userInfo;
    if (userInfo && [userInfo.allKeys containsObject:@"locationID"]) {
        DLog(@"Handling notification, fetching location from cache...");
        SSLocation *location = [[SSLocation whereFormat:@"rid == %@", [userInfo valueForKey:@"locationID"]] lastObject];
        if (location) {
            DLog(@"Location exists, presenting modal view for location...");
            [self presentLocationDetailInformationForLocation:location withAlert:showAlert];
        }
    }
}

- (void)clearNotifications
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)presentLocationDetailInformationForLocation:(SSLocation *)location withAlert:(BOOL)showAlert
{
    if (showAlert) {
        [UIAlertView alertViewWithTitle:@"Review" message:[NSString stringWithFormat:@"Review %@?", location.name] cancelButtonTitle:@"Cancel" otherButtonTitles:@[@"Show Details"] onDismiss:^(int buttonIndex) {
            if (buttonIndex == 0) {
                [self showLocationDetailViewControllerForLocation:location];
            }
        } onCancel:nil];
    } else {
        [self showLocationDetailViewControllerForLocation:location];
    }
}

- (void)showLocationDetailViewControllerForLocation:(SSLocation *)location
{
    UIViewController *currentViewController = self.window.rootViewController;
    SSLocationDetailViewController *locationDetailInformationController = [currentViewController.storyboard instantiateViewControllerWithIdentifier:@"LocationDetailViewController"];
    locationDetailInformationController.location = location;
    UINavigationController *locationDetailInformationNavigationController = [[UINavigationController alloc] initWithRootViewController:locationDetailInformationController];
    [locationDetailInformationController.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleDone target:self action:@selector(closeView)]];
    [currentViewController presentViewController:locationDetailInformationNavigationController animated:YES completion:nil];
}
     
- (void)closeView
{
    UIViewController *currentViewController = self.window.rootViewController;
    [currentViewController dismissViewControllerAnimated:YES completion:nil];
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
    
    [[UIBarButtonItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, 2) forBarMetrics:UIBarMetricsDefault];
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
