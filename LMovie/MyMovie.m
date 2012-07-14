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
@synthesize subtitle = _subtitle;
@synthesize language = _language;
@synthesize duration = _duration;


- (id)initWithTitle:(NSString *)title genre:(NSString *)genre year:(NSNumber *)year director:(NSString *)director picture:(NSData *)picture actors:(NSString *)actors duration:(NSNumber *)duration language:(NSString *)language subtitle:(NSString *)subtitle rate:(NSNumber *)rate viewed:(BOOL)viewed comment:(NSString *)comment
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
    _subtitle = subtitle;
    _language = language;
    _duration = duration;
    
    return self;
}


- (NSDictionary *)getAllInfo
{
    return [[NSDictionary alloc] initWithObjectsAndKeys:
                         self.actors, @"actors",
                          self.comment, @"comment",
                          self.director, @"director",
                          self.genre, @"genre",
                          self.picture, @"picture",
                          self.rate, @"rate",
                          self.title, @"title",
                          self.viewed, @"viewed",
                          self.year, @"year",
                          self.subtitle , @"subtitle",
                          self.language , @"language",
                          self.duration , @"duration",
                          nil];
}

-(NSString *)title
{
    if(_title == nil)
        _title = @"NO TITLE";
    return _title;
}

-(NSString *)genre
{
    if(_genre == nil)
        _genre = @"";
    return _genre;
}

- (NSNumber *)year
{
    if(_year == nil)
        _year = [NSNumber numberWithInt:0];
    return _year;
}

- (NSString *)director
{
    if(_director == nil)
        _director = @"";
    return _director;
}





- (NSData *)picture
{
    if(_picture == nil)
        _picture = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"emptyartwork.jpg"]];
    return _picture;
}

-(NSString *)actors
{
    if(_actors == nil)
        _actors = @"";
    return _actors;
}


- (NSNumber *)rate
{
    if(_rate == nil)
        _rate = [NSNumber numberWithInt:-1];
    return _rate;
}

- (NSNumber *)viewed
{
    if(_viewed == nil)
        _viewed = [NSNumber numberWithInt:NO];
    return _viewed;
}

- (NSString *)comment
{
    if(_comment == nil)
        _comment = @"";
    return _comment;
}


-(NSString *)language
{
    if(_language == nil)
        _language = @"";
    return _language;
}

-(NSString *)subtitle
{
    if(_subtitle == nil)
        _subtitle = @"";
    return _subtitle;
}

-(NSNumber *)duration
{
    if(_duration ==nil)
        _duration = [NSNumber numberWithInt:0];
    return _duration;
}




@end
