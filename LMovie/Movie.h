//
//  Movie.h
//  LMovie
//
//  Created by Jonathan Duss on 09.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Movie : NSManagedObject

@property (nonatomic, retain) NSString * actors;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSString * director;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSString * genre;
@property (nonatomic, retain) NSString * language;
@property (nonatomic, retain) NSData * picture;
@property (nonatomic, retain) NSNumber * user_rate;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * viewed;
@property (nonatomic, retain) NSNumber * year;
@property (nonatomic, retain) NSNumber * tmdb_rate;

@end
