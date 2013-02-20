//
//  SSLocationCell.m
//  SightSee
//
//  Created by Ross Beale on 19/02/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import "SSLocationCell.h"

#define kTextFrameWidth 300
#define kTextFrameLeftOffset 10
#define kTextFrameBottomOffset 5

@implementation SSLocationCell

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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (![ObservableKeys containsObject:keyPath]) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    if ([LocationKeyPath isEqualToString:keyPath])
    {
        id oldObj = [change objectForKey:NSKeyValueChangeOldKey];
        id newObj = [change objectForKey:NSKeyValueChangeNewKey];
        
        if (![oldObj isEqual:newObj]) {
            
            // Update UI
            self.locationNameLabel.text = self.location.name;
            CGSize constraint = CGSizeMake(kTextFrameWidth, 20000.0f);
            CGSize size = [self.location.desc sizeWithFont:[UIFont fontWithName:@"PTSans-Regular" size:self.locationDescriptionLabel.font.pointSize] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
            self.locationDescriptionLabel.frame = CGRectMake(self.locationDescriptionLabel.frame.origin.x, self.locationDescriptionLabel.frame.origin.y, size.width, size.height);
            self.locationDescriptionLabel.text = self.location.desc;
            self.locationDistanceLabel.frame = CGRectMake(kTextFrameLeftOffset, self.locationDescriptionLabel.frame.origin.y + self.locationDescriptionLabel.frame.size.height + ((self.location.desc.length == 0 ? 0 : kTextFrameBottomOffset)), self.locationDistanceLabel.frame.size.width, self.locationDistanceLabel.frame.size.height);
            self.locationDistanceLabel.text = [NSString stringWithFormat:@"%0.2f miles away", [self.location.distance floatValue]];
            self.locationRatingBar.frame = CGRectMake(kTextFrameLeftOffset, self.locationDistanceLabel.frame.origin.y + self.locationDistanceLabel.frame.size.height + kTextFrameBottomOffset, self.locationRatingBar.frame.size.width, self.locationRatingBar.frame.size.height);
            self.locationRatingBar.rating = [[self.location averageRating] floatValue];
        }
    }
}

- (void)dealloc
{
    // Tidy up and remove all the observers when the view is destroyed
    for (NSString *keyPath in ObservableKeys) {
        [self removeObserver:self forKeyPath:keyPath context:nil];
    }
}

#pragma mark - UI

- (void)awakeFromNib
{
    self.locationRatingBar.canEdit = NO;
    
    [self.locationNameLabel setFont:[UIFont fontWithName:@"PTSans-Bold" size:self.locationNameLabel.font.pointSize]];
    [self.locationDescriptionLabel setFont:[UIFont fontWithName:@"PTSans-Regular" size:self.locationDescriptionLabel.font.pointSize]];
    [self.locationDistanceLabel setFont:[UIFont fontWithName:@"PTSans-Regular" size:self.locationDistanceLabel.font.pointSize]];
}

- (void)prepareForReuse
{
    
}

+ (CGFloat)heightForCellWithLocation:(SSLocation *)location
{
    CGSize constraint = CGSizeMake(kTextFrameWidth, 20000.0f);
    if (location.desc.length == 0) {
        return 88.f;
    }
    CGSize size = [location.desc sizeWithFont:[UIFont fontWithName:@"PTSans-Regular" size:14.f] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    size.height += 95;
    return size.height;
}

@end
