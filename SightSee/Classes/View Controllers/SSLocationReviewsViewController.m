//
//  SSLocationReviewsViewController.m
//  SightSee
//
//  Created by Ross Beale on 22/02/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import "SSLocationReviewsViewController.h"
#import "SSBaseLocationCell.h"
#import "SSReviewCell.h"
#import "SSComposeReviewViewController.h"

@interface SSLocationReviewsViewController ()

@end

@implementation SSLocationReviewsViewController

- (void)viewWillAppear:(BOOL)animated
{
    if (_secondLoad) {
        [self.tableView reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"%@ Reviews", self.location.name];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _secondLoad = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButton];
    
    if ([segue.identifier isEqualToString:@"WriteReview"]) {
        
        SSComposeReviewViewController *destinationViewController = (SSComposeReviewViewController *)segue.destinationViewController;
        destinationViewController.location = self.location;
        
    }
}

#pragma mark - utility methods

- (SSReview *)reviewAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self.location.reviews allObjects] objectAtIndex:indexPath.row - 1];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.location.reviews count] + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) return 44.f;
    
    return [SSReviewCell heightForCellWithLocation:[self reviewAtIndexPath:indexPath]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        SSBaseLocationCell *cell = (SSBaseLocationCell *)[tableView dequeueReusableCellWithIdentifier:@"ActionCell" forIndexPath:indexPath];
        cell.dataLabel.text = @"Write a Review";
        return cell;
        
    }
    
    SSReviewCell *cell = (SSReviewCell *)[tableView dequeueReusableCellWithIdentifier:@"ReviewCell" forIndexPath:indexPath];
    cell.review = [self reviewAtIndexPath:indexPath];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) [self performSegueWithIdentifier:@"WriteReview" sender:self];
}

@end
