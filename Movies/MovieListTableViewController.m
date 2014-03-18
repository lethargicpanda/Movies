//
//  MovieListTableViewController.m
//  Movies
//
//  Created by Thomas Ezan on 3/16/14.
//  Copyright (c) 2014 Thomas Ezan. All rights reserved.
//

#import "MovieListTableViewController.h"
#import "Movie.h"
#import "MoviewCustomViewCell.h"
#import "MovieDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "AFNetworking.h"
#import "UINavigationBar+UINavigationBarAlert.h"

@interface MovieListTableViewController ()

@property (atomic, strong) NSArray *movieArray;

@end

@implementation MovieListTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Init pull to refresh
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    
    [refresh addTarget:self action:@selector(refreshData)
      forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl = refresh;
    
    [self refreshData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.movieArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MovieDetailViewController *movieDetail = [[MovieDetailViewController alloc] initWithNibName:@"MovieDetailViewController" bundle:nil];
    
    movieDetail.currMovie = self.movieArray[indexPath.row];
    [self.navigationController pushViewController:movieDetail animated:YES];
}

#pragma - Network communication
- (void) refreshData{
    
    NSLog([self isNetworkAvailable] ? @"Network Available!" : @"Network not Available!");
    
    if (![self isNetworkAvailable]) {
        [self.refreshControl endRefreshing];
        
        [self.navigationController.navigationBar showAlertWithTitle:@"No connection available!" hideAfter:2];
        
        
        return;
    }
    
    // Load the movie list
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=p2vfzyb9k8p39bazjp2cm43e";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *movieDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        self.movieArray = [Movie parseWithData:movieDictionary];
        [self.tableView reloadData];
        
    }];
    
    [self.refreshControl endRefreshing];
}

- (BOOL)isNetworkAvailable{
    CFNetDiagnosticRef dReference;
    dReference = CFNetDiagnosticCreateWithURL (NULL, (__bridge CFURLRef)[NSURL URLWithString:@"www.apple.com"]);
    
    CFNetDiagnosticStatus status;
    status = CFNetDiagnosticCopyNetworkStatusPassively (dReference, NULL);
    
    CFRelease (dReference);
    
    if ( status == kCFNetDiagnosticConnectionUp )
    {
        NSLog (@"Connection is Available");
        return YES;
    }
    else
    {
        NSLog (@"Connection is down");
        return NO;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}



@end
