//
//  SSDescriptionCell.h
//  SightSee
//
//  Created by Ross Beale on 21/02/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import "SSBaseLocationCell.h"

@interface SSDescriptionCell : SSBaseLocationCell

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

+ (CGFloat)heightForCellWithDescription:(NSString *)description;

@end
