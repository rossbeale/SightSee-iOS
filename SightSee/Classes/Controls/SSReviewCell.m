//
//  SSReviewCell.m
//  SightSee
//
//  Created by Ross Beale on 22/02/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import "SSReviewCell.h"

#define kTextFrameWidth 300
#define kTextFrameLeftOffset 10
#define kTextFrameBottomOffset 5
#define kCellHeightWithoutDesc 88
#define kCellOtherHeight 71

@implementation SSReviewCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        if (nil == ObservableKeys) {
            ObservableKeys = [[NSSet alloc] initWithObjects:ReviewKeyPath, nil];
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
    
    if ([ReviewKeyPath isEqualToString:keyPath])
    {
        id oldObj = [change objectForKey:NSKeyValueChangeOldKey];
        id newObj = [change objectForKey:NSKeyValueChangeNewKey];
        
        if (![oldObj isEqual:newObj]) {
            
            // Update UI
            self.ratingView.rating = [self.review.score floatValue];
            self.posterLabel.text = [NSString stringWithFormat:@"Posted by %@", self.review.reviewer];
            if (self.review.comment.length > 0) {
                CGSize constraint = CGSizeMake(kTextFrameWidth, 20000.0f);
                CGSize size = [self.review.comment sizeWithFont:[UIFont fontWithName:@"PTSans-Regular" size:self.commentLabel.font.pointSize] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
                self.commentLabel.frame = CGRectMake(self.commentLabel.frame.origin.x, self.commentLabel.frame.origin.y, size.width, size.height);
                self.commentLabel.text = self.review.comment;
            }
            
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

- (void)awakeFromNib
{
    self.clipsToBounds = YES;
    self.ratingView.canEdit = NO;
    [self setupFonts];
}

- (void)setupFonts
{
    [self.posterLabel setFont:[UIFont fontWithName:@"PTSans-Regular" size:self.posterLabel.font.pointSize]];
    [self.commentLabel setFont:[UIFont fontWithName:@"PTSans-Regular" size:self.commentLabel.font.pointSize]];
}

+ (CGFloat)heightForCellWithLocation:(SSReview *)review
{
    CGSize constraint = CGSizeMake(kTextFrameWidth, 20000.0f);
    if (review.comment.length == 0) {
        return kCellHeightWithoutDesc;
    }
    CGSize size = [review.comment sizeWithFont:[UIFont fontWithName:@"PTSans-Regular" size:14.f] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    size.height += kCellOtherHeight;
    return size.height;
}

@end
