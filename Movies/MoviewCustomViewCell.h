//
//  MoviewCustomViewCell.h
//  Movies
//
//  Created by Thomas Ezan on 3/15/14.
//  Copyright (c) 2014 Thomas Ezan. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MoviewCustomViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *sysnopis;
@property (weak, nonatomic) IBOutlet UILabel *cast;
@property (weak, nonatomic) IBOutlet UIImageView *poster;

@end
