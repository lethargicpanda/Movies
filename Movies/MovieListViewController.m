//
//  MovieListViewController.m
//  Movies
//
//  Created by Thomas Ezan on 3/12/14.
//  Copyright (c) 2014 Thomas Ezan. All rights reserved.
//

#import "MovieListViewController.h"
#import "Movie.h"
#import "MoviewCustomViewCell.h"
#import "MovieDetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MovieListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *movieListTableView;
//@property (atomic, strong) NSDictionary *movieList;
@property (atomic, strong) NSArray *movieArray;

@end

@implementation MovieListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.movieListTableView setDataSource:self];
    [self.movieListTableView setDelegate:self];
    
    
    // Init pull to refresh
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    
    [refresh addTarget:self action:@selector(refreshData)
      forControlEvents:UIControlEventValueChanged];
    
//    ((UITableViewController*)self.movieListTableView.dataSource).refreshControl = refresh;
    
    [self refreshData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - Network communication
- (void) refreshData{
    // Load the movie list
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=p2vfzyb9k8p39bazjp2cm43e";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *movieDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        self.movieArray = [Movie parseWithData:movieDictionary];
        [self.movieListTableView reloadData];
    
    }];
}

#pragma - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSDictionary *movieList = [self.movieList objectForKey:@"movies"];
    return self.movieArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"MovieCustomViewCell";
    
    MoviewCustomViewCell *cell = (MoviewCustomViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MovieCustomViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    
    // Set Title
    cell.title.text =((Movie *)self.movieArray[indexPath.row]).title;
    // Set Synopsis
    cell.sysnopis.text =((Movie *)self.movieArray[indexPath.row]).synopsis;
    // Set Cast
    cell.cast.text = [((Movie *)self.movieArray[indexPath.row]) getFormatedCast];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self.movieArray[indexPath.row] getDetailedPoster]]];
    
    
    [cell.poster setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"avatar"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        cell.poster.image = image;
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Failed with error: %@", error);
    }];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MovieDetailViewController *movieDetail = [[MovieDetailViewController alloc] initWithNibName:@"MovieDetailViewController" bundle:nil];
    
    movieDetail.currMovie = self.movieArray[indexPath.row];
    [self.navigationController pushViewController:movieDetail animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

@end
