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


@interface MovieManager : NSObject

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (readonly, strong) NSArray *allKey;

//- (void)insertNewMovie:(MyMovie *)movie;


- (void)insertMovieWithInformations:(NSDictionary *)info;

- (void)saveContext;

-(Movie *)modifyMovie:(Movie *)movie WithInformations:(NSDictionary *)info;
- (void)insertWithoutSavingMovieWithInformations:(NSDictionary *)info;


-(void)deleteMovie:(Movie *)movie;



-(NSArray *)keyOrderedBySection;


-(NSString *)keyAtIndexPath:(NSIndexPath *)path;
-(int)sectionForKey:(NSString *)key;
-(NSString *)labelForKey:(NSString *)key;
-(NSArray *)orderedKey;
-(NSString *)placeholderForKey:(NSString *)key;




+(NSString *)resolutionToStringForResolution:(LMResolution)resolution;
@end
