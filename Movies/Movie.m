//
//  Movie.m
//  Movies
//
//  Created by Thomas Ezan on 3/13/14.
//  Copyright (c) 2014 Thomas Ezan. All rights reserved.
//

#import "Movie.h"

@interface Movie ()

@end

@implementation Movie

- (NSString *) getFormatedCast{
    NSString *res = [[self.casting valueForKey:@"name"] componentsJoinedByString:@", "];
    
    return res;
}

- (NSString *) getProfilePoster{
    return [self.posterUrls objectForKey:@"profile"];
}

- (NSString *) getDetailedPoster{
   return [self.posterUrls objectForKey:@"detailed"];
}

- (NSString *) getOriginalPoster{
    return [self.posterUrls objectForKey:@"original"];
}

+ (NSArray *)parseWithData:(NSDictionary *)data {
    NSDictionary *movieList = [data objectForKey:@"movies"];

    
    NSLog(@"%i", movieList.count);

    NSMutableArray *res = [[NSMutableArray alloc] init];

    int index = 0;
    for (id movieObject in movieList) {
        Movie *currentMovie  = [[Movie alloc]init];
        currentMovie.title = [movieObject objectForKey:@"title"];
        currentMovie.synopsis = [movieObject objectForKey:@"synopsis"];
        currentMovie.casting = [movieObject objectForKey:@"abridged_cast"];
        currentMovie.runtime = [[movieObject objectForKey:@"runtime"] integerValue];
        currentMovie.mpaa_rating = [movieObject objectForKey:@"mpaa_rating"];
        currentMovie.critics_consensus = [movieObject objectForKey:@"critics_consensus"];
        currentMovie.ratings = [movieObject objectForKey:@"ratings"];
        currentMovie.posterUrls = [movieObject objectForKey:@"posters"];
        
        [res insertObject:currentMovie atIndex:index];
        index = index+1;
    }
    
    return res;
}


@end