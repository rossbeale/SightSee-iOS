//
//  SSDescriptionCell.h
//  SightSee
//
//  Created by Ross Beale on 21/02/2013.
//  Copyright (c) 2013 Ross Beale. All rights reserved.
//

#import "SSBaseCell.h"

@interface SSDescriptionCell : SSBaseCell

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

+ (CGFloat)heightForCellWithDescription:(NSString *)description;

@end
