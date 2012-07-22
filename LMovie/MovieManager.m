//
//  MovieManager.m
//  LMovie
//
//  Created by Jonathan Duss on 06.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovieManager.h"


@interface MovieManager ()
-(NSDictionary *)loadPlistValueOfKey:(NSString *)key;

@end

@implementation MovieManager

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize allKey = _allKey;

-(id)init
{
    DLog(@"Initialisation of MovieManager");
    AppDelegate *appDel = [UIApplication sharedApplication].delegate;
    _managedObjectContext = appDel.managedObjectContext;
    _managedObjectModel = appDel.managedObjectModel;
    _persistentStoreCoordinator = appDel.persistentStoreCoordinator;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Movie" inManagedObjectContext:_managedObjectContext ];
    _allKey = [[entity propertiesByName] allKeys];
    
    self = [super init];
    return self;
}




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
    UIImage *image = [utilities resizeImageToMini:[info valueForKey:@"picture"]];

    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    
    
    newMovie.title = [info valueForKey:@"title"];
    newMovie.genre = [info valueForKey:@"genre"];
    newMovie.year = [nf numberFromString:[info valueForKey:@"year"] ];
    newMovie.picture = UIImagePNGRepresentation(image);
    newMovie.director = [info valueForKey:@"director"];
    newMovie.actors = [info valueForKey:@"actor"];
    newMovie.user_rate = [nf numberFromString:[info valueForKey:@"user_rate"] ];
    newMovie.tmdb_rate = [nf numberFromString:[info valueForKey:@"tmdb_rate"] ];
    newMovie.viewed = [nf numberFromString:[info valueForKey:@"viewed"] ];
    newMovie.comment = [info valueForKey:@"comment"];
    newMovie.subtitle = [info valueForKey:@"subtitle"];
    newMovie.language = [info valueForKey:@"language"];
    newMovie.duration = [nf numberFromString:[info valueForKey:@"duration"] ];
    
   // DLog(@"new movie inserted: %@", [newMovie description]);
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
            DLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
        else {
            DLog(@"Context saved successfully");
        }
    }
}

-(Movie *)modifyMovie:(Movie *)movie WithInformations:(NSDictionary *)info
{
    Movie *movieToModify = movie;
    
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    UIImage *image = [utilities resizeImageToMini:[info valueForKey:@"picture"]];
    
    
    movieToModify.title = [info valueForKey:@"title"];
    movieToModify.genre = [info valueForKey:@"genre"];
    movieToModify.year = [nf numberFromString:[info valueForKey:@"year"] ];
    movieToModify.picture = UIImagePNGRepresentation(image);
    movieToModify.director = [info valueForKey:@"director"];
    movieToModify.actors = [info valueForKey:@"actor"];
    movieToModify.user_rate = [nf numberFromString:[info valueForKey:@"user_rate"] ];
    movieToModify.tmdb_rate = [nf numberFromString:[info valueForKey:@"tmdb_rate"] ];
    movieToModify.viewed = [nf numberFromString:[info valueForKey:@"viewed"] ];
    movieToModify.comment = [info valueForKey:@"comment"];
    movieToModify.subtitle = [info valueForKey:@"subtitle"];
    movieToModify.language = [info valueForKey:@"language"];
    movieToModify.duration = [nf numberFromString:[info valueForKey:@"duration"] ];
    
    // DLog(@"new movie inserted: %@", [newMovie description]);
    [self saveContext];
    return movieToModify;
}



/*-(void)insertNewMovie:(MyMovie *)movie
{
    NSManagedObjectContext *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Movie" inManagedObjectContext:self.managedObjectContext];
    
    NSDictionary *info = movie.getAllInfo;
    
    for (NSString *key in [info allKeys]) {
        [newManagedObject setValue:[info valueForKey:key] forKey:key];
    }
}*/


-(void)deleteMovie:(Movie *)movie{
    [_managedObjectContext deleteObject:movie];
}



#pragma mark - gestion des clé, de leur ordre, section associée etc
//Retourne soit le dico de la section associée à une variable d'un film, soit de l'ordre
-(NSDictionary *)loadPlistValueOfKey:(NSString *)key
{
    NSString *file = [[NSBundle mainBundle] pathForResource:@"Keys" ofType:@"plist"];  
    NSDictionary *dico = [NSDictionary dictionaryWithContentsOfFile:file];
    
    return [dico valueForKey:key];
}

-(NSArray *)orderedKey
{
    return (NSArray *)[self loadPlistValueOfKey:@"order"];
}

-(NSArray *)keyOrderedBySection{
    NSMutableArray *indexPathOrdered = [[NSMutableArray alloc] init];
    [indexPathOrdered addObject:[[NSArray alloc] init]];
    [indexPathOrdered addObject:[[NSArray alloc] init]];
    
    NSDictionary *sectionInfo = [self loadPlistValueOfKey:@"section"];
     NSArray *keyOrdered = (NSArray *)[self loadPlistValueOfKey:@"order"];
    
    for(NSString *key in keyOrdered){
        int section = [[sectionInfo valueForKey:key] intValue];
        [indexPathOrdered insertObject:key atIndex:section];
    }
    
    return [indexPathOrdered copy];

}


-(NSString *)keyAtIndexPath:(NSIndexPath *)path
{
    return [[[self keyOrderedBySection] objectAtIndex:path.section] objectAtIndex:path.row];
}


-(int)sectionForKey:(NSString *)key{
    NSDictionary *dico = [self loadPlistValueOfKey:@"section"];
    return [[dico valueForKey:key] intValue];
}

-(NSString *)labelForKey:(NSString *)key
{
    return [[self loadPlistValueOfKey:@"label"] valueForKey:key];
}




@end
