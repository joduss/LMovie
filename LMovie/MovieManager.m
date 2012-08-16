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

    NSLog(@"ERREUR, ERREUR ERREUR");
    
    return nil;
}


- (void)insertMovieWithInformations:(NSDictionary *)info
{    
   // DLog(@"new movie inserted: %@", [newMovie description]);
    [self insertWithoutSavingMovieWithInformations:info];
    [self saveContext];
    
}

- (void)insertWithoutSavingMovieWithInformations:(NSDictionary *)info
{
    
    Movie* newMovie = (Movie *)[NSEntityDescription insertNewObjectForEntityForName:@"Movie" inManagedObjectContext:self.managedObjectContext];
    DLog(@"info: %@", [info description]);
    UIImage *mini_image = [utilities resizeImageToMini:[info valueForKey:@"mini_picture"]];
    UIImage *big_image = [utilities resizeImageToBig:[info valueForKey:@"big_picture"]];
    
    
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    
    if([[info valueForKey:@"viewed"] isEqualToString:@"✕"]){
        [info setValue:@"0" forKey:@"viewed"];
    }
    else if([[info valueForKey:@"viewed"] isEqualToString:@"✓"]){
        [info setValue:@"1" forKey:@"viewed"];
    }
    else if([[info valueForKey:@"viewed"] isEqualToString:@"?"]){
        [info setValue:@"2" forKey:@"viewed"];
    }
    
    
    newMovie.mini_picture = UIImagePNGRepresentation(mini_image);
    newMovie.big_picture = UIImagePNGRepresentation(big_image);
    
    newMovie.title = [info valueForKey:@"title"];
    newMovie.year = [nf numberFromString:[info valueForKey:@"year"] ];
    newMovie.duration = [nf numberFromString:[info valueForKey:@"duration"] ];
    newMovie.genre = [info valueForKey:@"genre"];
    newMovie.director = [info valueForKey:@"director"];
    newMovie.actors = [info valueForKey:@"actors"];
    newMovie.tmdb_rate = [nf numberFromString:[info valueForKey:@"tmdb_rate"] ];
    
    newMovie.language = [info valueForKey:@"language"];
    newMovie.subtitle = [info valueForKey:@"subtitle"];
    newMovie.resolution = [info valueForKey:@"resolution"];
    newMovie.user_rate = [nf numberFromString:[info valueForKey:@"user_rate"] ];
    newMovie.viewed = [nf numberFromString:[info valueForKey:@"viewed"] ];
    newMovie.comment = [info valueForKey:@"comment"];
    
    
    // DLog(@"new movie inserted: %@", [newMovie description]);    
}



-(Movie *)modifyMovie:(Movie *)movie WithInformations:(NSDictionary *)info
{
    Movie *movieToModify = movie;
    
    DLog(@"info mises à jour lors de la modif: %@", [info description]);

    
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    UIImage *mini_image = [utilities resizeImageToMini:[info valueForKey:@"mini_picture"]];
    UIImage *big_image = [utilities resizeImageToBig:[info valueForKey:@"big_picture"]];    
    
    
    movieToModify.big_picture = UIImagePNGRepresentation(big_image);
    movieToModify.mini_picture = UIImagePNGRepresentation(mini_image);
    movieToModify.title = [info valueForKey:@"title"];
    movieToModify.year = [nf numberFromString:[info valueForKey:@"year"] ];
    movieToModify.duration = [nf numberFromString:[info valueForKey:@"duration"] ];
    movieToModify.genre = [info valueForKey:@"genre"];
    movieToModify.director = [info valueForKey:@"director"];
    movieToModify.actors = [info valueForKey:@"actors"];
    movieToModify.tmdb_rate = [nf numberFromString:[info valueForKey:@"tmdb_rate"] ];
    movieToModify.subtitle = [info valueForKey:@"subtitle"];
    movieToModify.language = [info valueForKey:@"language"];
    movieToModify.resolution = [info valueForKey:@"resolution"];
    movieToModify.user_rate = [nf numberFromString:[info valueForKey:@"user_rate"] ];
    movieToModify.viewed = [nf numberFromString:[info valueForKey:@"viewed"] ];
    movieToModify.comment = [info valueForKey:@"comment"];

    
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
    [indexPathOrdered addObject:[[NSMutableArray alloc] init]];
    [indexPathOrdered addObject:[[NSMutableArray alloc] init]];
    
    NSDictionary *sectionInfo = [self loadPlistValueOfKey:@"section"];
     NSArray *keyOrdered = (NSArray *)[self loadPlistValueOfKey:@"order"];
    
    for(NSString *key in keyOrdered){
        int section = [[sectionInfo valueForKey:key] intValue];
        [[indexPathOrdered objectAtIndex:section] addObject:key];
        //[indexPathOrdered insertObject:key atIndex:section];
    }
    
    return [indexPathOrdered copy];

}


-(NSString *)keyAtIndexPath:(NSIndexPath *)path
{
    return [[[self keyOrderedBySection] objectAtIndex:path.section] objectAtIndex:path.row];
}


-(int)sectionForKey:(NSString *)key{
    NSDictionary *dico = [self loadPlistValueOfKey:@"section"];
    return [[dico valueForKey:key] floatValue];
}

-(NSString *)labelForKey:(NSString *)key
{
    return [[self loadPlistValueOfKey:@"label"] valueForKey:key];
}

-(NSString *)placeholderForKey:(NSString *)key
{
    return [[self loadPlistValueOfKey:@"placeholder"] valueForKey:key];
}









@end
