//
//  MyMovie.m
//  LMovie
//
//  Created by Jonathan Duss on 07.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyMovie.h"

@implementation MyMovie

@synthesize title = _title;
@synthesize genre = _genre;
@synthesize year = _year;
@synthesize director = _director;
@synthesize picture = _picture;
@synthesize actors = _actors;
@synthesize rate = _rate;
@synthesize viewed = _viewed;
@synthesize comment = _comment;


- (id)initWithTitle:(NSString *)title genre:(NSString *)genre year:(NSNumber *)year director:(NSString *)director picture:(NSData *)picture actors:(NSString *)actors rate:(NSNumber *)rate viewed:(BOOL)viewed comment:(NSString *)comment
{
    self = [super init];
    _title = title;
    _genre = genre;
    _year = year;
    _picture = picture;
    _director = director;
    _actors = actors;
    _rate = rate;
    _viewed = [NSNumber numberWithInt:viewed];
    _comment = comment;
    
    return self;
}


- (NSDictionary *)getAllInfo
{
    return [[NSDictionary alloc] initWithObjectsAndKeys:
                          _actors, @"actors",
                          _comment, @"comment",
                          _director, @"director",
                          _genre, @"genre",
                          _picture, @"picture",
                          _rate, @"rate",
                          _title, @"title",
                          _viewed, @"viewed",
                          _year, @"year", 
                          nil];
}


@end
