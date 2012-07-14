//
//  MovieManager.m
//  LMovie
//
//  Created by Jonathan Duss on 06.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovieManager.h"



@implementation MovieManager

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize allKey = _allKey;

-(id)init
{
    NSLog(@"Initialisation of MovieManager");
    AppDelegate *appDel = [UIApplication sharedApplication].delegate;
    _managedObjectContext = appDel.managedObjectContext;
    _managedObjectModel = appDel.managedObjectModel;
    _persistentStoreCoordinator = appDel.persistentStoreCoordinator;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Movie" inManagedObjectContext:_managedObjectContext ];
    _allKey = [[entity propertiesByName] allKeys];
    
    self = [super init];
    return self;
}



/*- (void)insertNewObject:(id)sender
{
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    NSMutableDictionary *dico = [[NSMutableDictionary alloc] init];
    NSData *data = [[NSData alloc] initWithContentsOfFile:@"IMG_1458.JPG"];
    [dico setValue:data forKey:@"picture"];
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    [newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}*/

- (Movie *)insertNewMovieWithTitle:(NSString *)title genre:(NSString *)genre year:(NSNumber *)year director:(NSString *)director picture:(NSData *)picture actors:(NSString *)actors duration:(NSNumber *)duration language:(NSString *)language subtitle:(NSString *)subtitle userRate:(NSNumber *)userRate tmdbRate:(NSNumber *)tmdbRate viewed:(BOOL)viewed comment:(NSString *)comment
{

    Movie *newMovie = [NSEntityDescription insertNewObjectForEntityForName:@"Movie" inManagedObjectContext:_managedObjectContext];
    
    newMovie.title = title;
    newMovie.genre = genre;
    newMovie.year = year;
    newMovie.picture = picture;
    newMovie.director = director;
    newMovie.actors = actors;
    newMovie.user_rate = userRate;
    newMovie.tmdb_rate = tmdbRate;
    newMovie.viewed = [NSNumber numberWithInt:viewed];
    newMovie.comment = comment;
    newMovie.subtitle = subtitle;
    newMovie.language = language;
    newMovie.duration = duration;
    
    return newMovie;
}


- (void)insertMovieWithInformations:(NSDictionary *)info
{
    
    Movie* newMovie = (Movie *)[NSEntityDescription insertNewObjectForEntityForName:@"Movie" inManagedObjectContext:self.managedObjectContext];
    

    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    
    
    newMovie.title = [info valueForKey:@"title"];
    newMovie.genre = [info valueForKey:@"genre"];
    newMovie.year = [nf numberFromString:[info valueForKey:@"year"] ];
    newMovie.picture = [info valueForKey:@"picture"];
    newMovie.director = [info valueForKey:@"director"];
    newMovie.actors = [info valueForKey:@"actor"];
    newMovie.user_rate = [nf numberFromString:[info valueForKey:@"user_rate"] ];
    newMovie.tmdb_rate = [nf numberFromString:[info valueForKey:@"tmdb_rate"] ];
    newMovie.viewed = [nf numberFromString:[info valueForKey:@"viewed"] ];
    newMovie.comment = [info valueForKey:@"comment"];
    newMovie.subtitle = [info valueForKey:@"subtitle"];
    newMovie.language = [info valueForKey:@"language"];
    newMovie.duration = [nf numberFromString:[info valueForKey:@"duration"] ];
    
   // NSLog(@"new movie inserted: %@", [newMovie description]);
    [self saveContext];
    
}


- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
        else {
            NSLog(@"Context saved successfully");
        }
    }
}

-(void)modifyMovie:(Movie *)movie WithInformations:(NSDictionary *)info
{
    Movie *movieToModify = movie;
    
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    
    
    movieToModify.title = [info valueForKey:@"title"];
    movieToModify.genre = [info valueForKey:@"genre"];
    movieToModify.year = [nf numberFromString:[info valueForKey:@"year"] ];
    movieToModify.picture = [info valueForKey:@"picture"];
    movieToModify.director = [info valueForKey:@"director"];
    movieToModify.actors = [info valueForKey:@"actor"];
    movieToModify.user_rate = [nf numberFromString:[info valueForKey:@"user_rate"] ];
    movieToModify.tmdb_rate = [nf numberFromString:[info valueForKey:@"tmdb_rate"] ];
    movieToModify.viewed = [nf numberFromString:[info valueForKey:@"viewed"] ];
    movieToModify.comment = [info valueForKey:@"comment"];
    movieToModify.subtitle = [info valueForKey:@"subtitle"];
    movieToModify.language = [info valueForKey:@"language"];
    movieToModify.duration = [nf numberFromString:[info valueForKey:@"duration"] ];
    
    // NSLog(@"new movie inserted: %@", [newMovie description]);
    [self saveContext];
}



/*-(void)insertNewMovie:(MyMovie *)movie
{
    NSManagedObjectContext *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Movie" inManagedObjectContext:self.managedObjectContext];
    
    NSDictionary *info = movie.getAllInfo;
    
    for (NSString *key in [info allKeys]) {
        [newManagedObject setValue:[info valueForKey:key] forKey:key];
    }
}*/




@end
