//
//  SSLocationDetailViewController.m
//  SightSee
//
//  Created by Ross Beale on 19/02/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import "SSLocationDetailViewController.h"

@interface SSLocationDetailViewController ()

@end

@implementation SSLocationDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.location.name;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
