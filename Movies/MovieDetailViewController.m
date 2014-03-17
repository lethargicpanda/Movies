//
//  MovieDetailViewController.m
//  Movies
//
//  Created by Thomas Ezan on 3/15/14.
//  Copyright (c) 2014 Thomas Ezan. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "Movie.h"
#import "UIImageView+AFNetworking.h"

@interface MovieDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *synopsisView;
@property (weak, nonatomic) IBOutlet UILabel *castView;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;

@end

@implementation MovieDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withMovie:(Movie*)movie
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.currMovie = movie;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.synopsisView.text = self.currMovie.synopsis;
    self.castView.text = [self.currMovie getFormatedCast];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self.currMovie getOriginalPoster ]]];
    [self.posterView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"avatar"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        NSLog(@"Done");
        self.posterView.image = image;
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Failed with error: %@", error);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
