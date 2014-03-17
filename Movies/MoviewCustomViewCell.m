//
//  MoviewCustomViewCell.m
//  Movies
//
//  Created by Thomas Ezan on 3/15/14.
//  Copyright (c) 2014 Thomas Ezan. All rights reserved.
//

#import "MoviewCustomViewCell.h"

@implementation MoviewCustomViewCell

@synthesize title = _title;
@synthesize sysnopis = _sysnopis;
@synthesize cast = _cast;
@synthesize poster = _poster;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
