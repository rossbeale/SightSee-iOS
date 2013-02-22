//
//  SSBaseCell.h
//  SightSee
//
//  Created by Ross Beale on 21/02/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSLocation.h"

static NSString * const LocationKeyPath = @"location";

@interface SSBaseLocationCell : UITableViewCell {
@protected
    NSSet *ObservableKeys;
}

@property (nonatomic, weak) SSLocation *location;

@property IBOutletCollection(UILabel) NSArray *standardLabels;
@property IBOutletCollection(UILabel) NSArray *boldLabels;

// UI elements
@property (weak, nonatomic) IBOutlet UILabel *dataLabel;
@property (weak, nonatomic) IBOutlet UILabel *detaildataLabel;

@end
