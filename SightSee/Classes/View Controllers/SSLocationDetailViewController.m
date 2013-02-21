//
//  SSLocationDetailViewController.m
//  SightSee
//
//  Created by Ross Beale on 19/02/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import "SSLocationDetailViewController.h"
#import "SSMapViewCell.h"
#import "SSReviewInformationCell.h"
#import "SSDescriptionCell.h"
#import "SSComposeReviewViewController.h"

@interface SSLocationDetailViewController ()

@end

@implementation SSLocationDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.location.name;
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            if ([self.location hasDescription]) return 5;
            return 4;
            break;
            
        default:
            return 3;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    return 150.f;
                case 2:
                    if ([self.location hasDescription]) return [SSDescriptionCell heightForCellWithDescription:self.location.desc];
                    return 44.f;
                break;
                default:
                    return 44.f;
                    break;
            }
            break;
            
        default:
            return 44.f;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                {
                    return [self cellForCellType:kCellTypeMapView atIndexPath:indexPath];
                }
                    break;
                case 1:
                {
                    return [self cellForCellType:kCellTypeName atIndexPath:indexPath];
                }
                case 2:
                {
                    if ([self.location hasDescription]) {
                        return [self cellForCellType:kCellTypeDescription atIndexPath:indexPath];
                    } else {
                        return [self cellForCellType:kCellTypeDistance atIndexPath:indexPath];
                    }
                }
                case 3:
                {
                    if ([self.location hasDescription]) {
                        return [self cellForCellType:kCellTypeDistance atIndexPath:indexPath];
                    } else {
                        return [self cellForCellType:kCellTypeReview atIndexPath:indexPath];
                    }
                }
                case 4:
                {
                    return [self cellForCellType:kCellTypeReview atIndexPath:indexPath];
                }
                default:
                    return 0;
                    break;
            }
            break;
            
        default:
        {
            SSBaseCell *cell = (SSBaseCell *)[tableView dequeueReusableCellWithIdentifier:@"ActionCell" forIndexPath:indexPath];
            switch (indexPath.row) {
                case 0:
                    if ([self.location hasReviews]) {
                        cell.dataLabel.text = @"View Reviews";
                    } else {
                        cell.dataLabel.text = @"Write a Review";
                    }
                    break;
                case 1:
                    cell.dataLabel.text = @"View Directions";
                    break;
                default:
                    cell.dataLabel.text = @"Share";
                    break;
            }
            return cell;
            break;
        }
    }
}

- (UITableViewCell *)cellForCellType:(kCellType)cellType atIndexPath:(NSIndexPath *)indexPath
{
    switch (cellType) {
        case kCellTypeMapView:
        {
            SSMapViewCell *cell = (SSMapViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"MapViewCell" forIndexPath:indexPath];
            cell.location = self.location;
            return cell;
        }
            break;
        case kCellTypeName:
        {
            SSBaseCell *cell = (SSBaseCell *)[self.tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];
            cell.detaildataLabel.text = @"Name";
            cell.dataLabel.text = self.location.name;
            return cell;
        }
            break;
        case kCellTypeDescription:
        {
            SSDescriptionCell *cell = (SSDescriptionCell *)[self.tableView dequeueReusableCellWithIdentifier:@"DescriptionCell" forIndexPath:indexPath];
            CGSize constraint = CGSizeMake(278, 20000.0f);
            CGSize size = [self.location.desc sizeWithFont:[UIFont fontWithName:@"PTSans-Regular" size:cell.descriptionLabel.font.pointSize] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
            cell.descriptionLabel.frame = CGRectMake(cell.descriptionLabel.frame.origin.x, cell.descriptionLabel.frame.origin.y, size.width, size.height);
            cell.descriptionLabel.text = self.location.desc;
            return cell;
        }
            break;
        case kCellTypeDistance:
        {
            SSBaseCell *cell = (SSBaseCell *)[self.tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];
            cell.detaildataLabel.text = @"Distance";
            cell.dataLabel.text = [NSString stringWithFormat:@"%0.2f miles away", [self.location.distance floatValue]];
            return cell;
        }
            break;
        case kCellTypeReview:
        {
            SSReviewInformationCell *cell = (SSReviewInformationCell *)[self.tableView dequeueReusableCellWithIdentifier:@"ReviewInformationCell" forIndexPath:indexPath];
            cell.location = self.location;
            return cell;
        }
            break;
    }
}

#pragma mark - Table view delegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.section == 1);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            if ([self.location hasReviews]) {
                // View reviews
            } else {
                // Compose a review
                [self performSegueWithIdentifier:@"WriteReview" sender:self];
            }
        }
            break;
        case 1:
        {
            // View directions
        }
            break;
        case 2:
        {
            // Share
            NSString *shareImage = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%f,%f+(%@)&z=%f,%f&z=17", [self.location.lat doubleValue], [self.location.lng doubleValue], [self.location.name stringByReplacingOccurrencesOfString:@" " withString:@"+"], [self.location.lat doubleValue], [self.location.lng doubleValue]];
            NSString *shareString = [self.location.name stringByAppendingString:@" - found on SightSee!"];
            NSArray *dataToShare = @[shareString, shareImage];
            UIActivityViewController* activityViewController = [[UIActivityViewController alloc] initWithActivityItems:dataToShare applicationActivities:nil];
            [self presentViewController:activityViewController animated:YES completion:^{
                [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            }];
        }
            break;
    }
}

@end
