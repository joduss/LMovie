//
//  Movie.h
//  LMovieB
//
//  Created by Jonathan Duss on 07.02.13.
//
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
@property (nonatomic, retain) NSNumber * resolution;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * tmdb_ID;
@property (nonatomic, retain) NSNumber * tmdb_rate;
@property (nonatomic, retain) NSNumber * user_rate;
@property (nonatomic, retain) NSNumber * viewed;
@property (nonatomic, retain) NSNumber * year;
@property (nonatomic, retain) NSManagedObject *cover;

@end
