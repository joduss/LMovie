//
//  Cover.h
//  LMovieB
//
//  Created by Jonathan Duss on 07.02.13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Movie;

@interface Cover : NSManagedObject

@property (nonatomic, retain) NSData * big_cover;
@property (nonatomic, retain) NSData * mini_cover;
@property (nonatomic, retain) Movie *movie;

@end
