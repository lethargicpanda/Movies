//
//  Movie.h
//  Movies
//
//  Created by Thomas Ezan on 3/13/14.
//  Copyright (c) 2014 Thomas Ezan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject
+ (NSArray *)parseWithData:(NSDictionary *)data;
- (NSString *)getFormatedCast;
- (NSString *) getProfilePoster;
- (NSString *) getDetailedPoster;
- (NSString *) getOriginalPoster;


@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *synopsis;
@property (nonatomic, retain) NSArray *casting;
@property (nonatomic, assign) NSInteger runtime;
@property (nonatomic, retain) NSString *mpaa_rating;
@property (nonatomic, retain) NSString *critics_consensus;
@property (nonatomic, retain) NSDictionary *ratings;
@property (nonatomic, retain) NSDictionary *posterUrls;

@end
