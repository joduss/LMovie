//
//  MovieManager.h
//  LMovie
//
//  Created by Jonathan Duss on 06.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Movie.h"
#import "Movie+Info.h"
#import "AppDelegate.h"
#import "utilities.h"

typedef enum LMResolution {
    LMResolutionUnknown = 0,
    LMResolutionAVI = 1,
    LMResolutionDVD = 2,
    LMResolution720 = 3,
    LMResolution1080 = 4,
    LMResolution3D = 5,
    LMResolutionAll = 6
} LMResolution;


typedef enum LMViewed {
    LMViewedNO = 0,
    LMViewedYES = 1,
    LMViewedUnknown = 2
} LMViewed;



/**
 Manage the Access to the CoreData database, which contains all movies
 */
@interface MovieManager : NSObject

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (readonly, strong) NSArray *allKey;
@property (readonly, strong) NSArray *keyOrderedBySection;

//- (void)insertNewMovie:(MyMovie *)movie;


- (void)insertMovieWithInformations:(NSDictionary *)info;

- (void)saveContext;

-(Movie *)modifyMovie:(Movie *)movie WithInformations:(NSDictionary *)info;
- (void)insertWithoutSavingMovieWithInformations:(NSDictionary *)info;


-(void)deleteMovie:(Movie *)movie;



-(NSArray *)keyOrderedBySection;


-(NSString *)keyAtIndexPath:(NSIndexPath *)path;
/**
 Return the section in which a key should be in the MovieInfoTVC
 @param key the key we want to know the section
 @return the section
 */
-(int)sectionForKey:(NSString *)key;
-(NSString *)labelForKey:(NSString *)key;

/**
 Return the key in the order it should be displayed in the TableView showing all info about a movie
 @return An array with the key in the correct order
 */
-(NSArray *)orderedKey;

/**
 Return the associated placeholder
 @param key the key for which we want the placeholder
 @return the placeholder value
 */
-(NSString *)placeholderForKey:(NSString *)key;




+(NSString *)resolutionToStringForResolution:(LMResolution)resolution;
@end
