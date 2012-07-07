//
//  Movie.h
//  LMovie
//
//  Created by Jonathan Duss on 06.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Movie : NSManagedObject

@property (nonatomic, retain) NSString * actors;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSString * director;
@property (nonatomic, retain) NSString * genre;
@property (nonatomic, retain) NSData * picture;
@property (nonatomic, retain) NSNumber * rate;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * viewed;
@property (nonatomic, retain) NSNumber * year;

@end
