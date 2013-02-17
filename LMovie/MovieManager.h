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
#import "MovieManagerUtils.h"
#import "Cover.h"








/**
 Manage the Access to the CoreData database, which contains all movies
 */
@interface MovieManager : NSObject

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;

//@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) NSManagedObjectContext *tempContext;


+(MovieManager *)instance;

//- (void)insertNewMovie:(MyMovie *)movie;
-(Movie *)newMovie;
//-(void)storeMovie:(Movie *)movie;

- (void)insertWithoutSavingMovieWithInformations:(NSDictionary *)infoAboutMovie;


- (void)insertMovieWithInformations:(NSDictionary *)info;

- (void)saveContext;

-(void)deleteMovie:(Movie *)movie;

-(void)deleteAll;




@end
