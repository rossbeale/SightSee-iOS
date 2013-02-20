//
//  SSSavingTabBarDelegate.m
//  SightSee
//
//  Created by Ross Beale on 18/02/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import "SSSavingTabBarController.h"

@implementation SSSavingTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.delegate = self;
    self.selectedIndex = [[SSPreferencesManager userDefaultForKey:kUserDefaultsKeyStartingTab] integerValue];
    DLog(@"Loaded tab preference...");
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;
{
    DLog(@"Saving tab preference...");
    [SSPreferencesManager setUserDefaultValue:[NSNumber numberWithUnsignedInteger:tabBarController.selectedIndex] forKey:kUserDefaultsKeyStartingTab];
}

@end
