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
@interface MovieManager : NSObject

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (readonly, strong) NSArray *allKey;

//- (void)insertNewMovie:(MyMovie *)movie;
- (Movie *)insertNewMovieWithTitle:(NSString *)title genre:(NSString *)genre year:(NSNumber *)year director:(NSString *)director picture:(NSData *)picture actors:(NSString *)actors duration:(NSNumber *)duration language:(NSString *)language subtitle:(NSString *)subtitle userRate:(NSNumber *)userRate tmdbRate:(NSNumber *)tmdbRate viewed:(BOOL)viewed comment:(NSString *)comment;

- (void)insertMovieWithInformations:(NSDictionary *)info;

- (void)saveContext;

-(Movie *)modifyMovie:(Movie *)movie WithInformations:(NSDictionary *)info;

-(void)deleteMovie:(Movie *)movie;



-(NSArray *)keyOrderedBySection;


-(NSString *)keyAtIndexPath:(NSIndexPath *)path;
-(int)sectionForKey:(NSString *)key;
-(NSString *)labelForKey:(NSString *)key;
-(NSArray *)orderedKey;

@end
