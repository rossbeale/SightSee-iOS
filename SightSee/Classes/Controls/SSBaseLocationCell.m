//
//  SSBaseCell.m
//  SightSee
//
//  Created by Ross Beale on 21/02/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import "SSBaseLocationCell.h"

@implementation SSBaseLocationCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        if (nil == ObservableKeys) {
            ObservableKeys = [[NSSet alloc] initWithObjects:LocationKeyPath, nil];
        }
        
        // Add observers for KVC
        for (NSString *keyPath in ObservableKeys) {
            [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
        }
    }
    
    return self;
}

- (void)dealloc
{
    // Tidy up and remove all the observers when the view is destroyed
    for (NSString *keyPath in ObservableKeys) {
        [self removeObserver:self forKeyPath:keyPath context:nil];
    }
}

#pragma mark - setup UI

- (void)awakeFromNib
{
    [self setupFonts];
}

- (void)setupFonts
{
    for (UILabel *label in self.standardLabels) {
        [label setFont:[UIFont fontWithName:@"PTSans-Regular" size:label.font.pointSize]];
    }
    for (UILabel *label in self.boldLabels) {
        [label setFont:[UIFont fontWithName:@"PTSans-Bold" size:label.font.pointSize]];
    }
}

@end
