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
- (void)controlInfoDico:(NSMutableDictionary *)info;
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

- (void)insertWithoutSavingMovieWithInformations:(NSDictionary *)infoAboutMovie
{
    NSMutableDictionary *info = [infoAboutMovie mutableCopy];
    [self controlInfoDico:info];

    Movie* newMovie = (Movie *)[NSEntityDescription insertNewObjectForEntityForName:@"Movie" inManagedObjectContext:self.managedObjectContext];
    DLog(@"info: %@", [info description]);
    UIImage *mini_image = [utilities resizeImageToMini:[info valueForKey:@"big_picture"]];
    UIImage *big_image = [utilities resizeImageToBig:[info valueForKey:@"big_picture"]];
    
    
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    
    int user_rate;
    if(! [info valueForKey:@"user_rate"]){
        user_rate = 0;
    }
    else{
        user_rate = [[info valueForKey:@"user_rate"] intValue];
    }
    
    int tmdb_rate;
    if(! [info valueForKey:@"tmdb_rate"]){
        tmdb_rate = 0;
    }
    else{
        tmdb_rate = [[info valueForKey:@"tmd_rate"] intValue];
    }
    
    
    
    newMovie.mini_picture = UIImagePNGRepresentation(mini_image);
    newMovie.big_picture = UIImagePNGRepresentation(big_image);
    
    newMovie.title = [info valueForKey:@"title"];
    newMovie.year = [nf numberFromString:[info valueForKey:@"year"] ];
    newMovie.duration = [nf numberFromString:[info valueForKey:@"duration"] ];
    newMovie.genre = [info valueForKey:@"genre"];
    newMovie.director = [info valueForKey:@"director"];
    newMovie.actors = [info valueForKey:@"actors"];
    newMovie.tmdb_rate = [NSNumber numberWithInt:tmdb_rate];
    newMovie.tmdb_ID = [nf numberFromString:[info valueForKey:@"tmdb_ID"] ];
    
    newMovie.language = [info valueForKey:@"language"];
    newMovie.subtitle = [info valueForKey:@"subtitle"];
    newMovie.resolution = [nf numberFromString:[info valueForKey:@"resolution"]];
    newMovie.user_rate = [NSNumber numberWithInt:user_rate];
    newMovie.viewed = [nf numberFromString:[info valueForKey:@"viewed"] ];
    newMovie.comment = [info valueForKey:@"comment"];
    
    
    // DLog(@"new movie inserted: %@", [newMovie description]);    
}



-(Movie *)modifyMovie:(Movie *)movie WithInformations:(NSDictionary *)infoAboutMovie
{
    Movie *movieToModify = movie;
    
    
    //DLog(@"tmdb_rate: %@", [info valueForKey:@"tmdb_rate"]);
    NSMutableDictionary *info = [infoAboutMovie mutableCopy];
    DLog(@"MovieManager | Mise à jour de Movie avec ces nouvelles info: %@", [info description]);
    
    
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    UIImage *mini_image = [utilities resizeImageToMini:[info valueForKey:@"big_picture"]];
    UIImage *big_image = [utilities resizeImageToBig:[info valueForKey:@"big_picture"]];    
    
   
    int user_rate;
    if(! [info valueForKey:@"user_rate"]){
        user_rate = 0;
    }
    else{
        user_rate = [[info valueForKey:@"user_rate"] intValue];
    }
        
        int tmdb_rate;
        if(! [info valueForKey:@"tmdb_rate"]){
            tmdb_rate = 0;
        }
        else{
            tmdb_rate = [[info valueForKey:@"tmd_rate"] intValue];
        }
    
    
    movieToModify.big_picture = UIImagePNGRepresentation(big_image);
    movieToModify.mini_picture = UIImagePNGRepresentation(mini_image);
    movieToModify.title = [info valueForKey:@"title"];
    movieToModify.year = [nf numberFromString:[info valueForKey:@"year"] ];
    movieToModify.duration = [nf numberFromString:[info valueForKey:@"duration"] ];
    movieToModify.genre = [info valueForKey:@"genre"];
    movieToModify.director = [info valueForKey:@"director"];
    movieToModify.actors = [info valueForKey:@"actors"];
    movieToModify.tmdb_rate = [NSNumber numberWithInt:tmdb_rate];
    movieToModify.tmdb_ID = [nf numberFromString:[info valueForKey:@"tmdb_ID"] ];
    movieToModify.subtitle = [info valueForKey:@"subtitle"];
    movieToModify.language = [info valueForKey:@"language"];
    movieToModify.resolution = [nf numberFromString:[info valueForKey:@"resolution"]];
    movieToModify.user_rate = [NSNumber numberWithInt:user_rate];
    movieToModify.viewed = [nf numberFromString:[info valueForKey:@"viewed"] ];
    movieToModify.comment = [info valueForKey:@"comment"];

    
    DLog(@"MovieManager | résultat de la modification de Movie: %@", [movieToModify description]);
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




- (void)controlInfoDico:(NSMutableDictionary *)info
{
    if([info valueForKey:@"viewed"] == nil){
        [info setValue:[NSString stringWithFormat:@"%d", LMViewedUnknown] forKey:@"viewed"];
    }
    if([info valueForKey:@"resolution"] == nil){
        [info setValue:[NSString stringWithFormat:@"%d", LMResolutionUnknown] forKey:@"resolution"];
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
    DLog(@"langue label: %d", [[SettingsLoader settings] language]);

    
    DLog(@"Langue: %d", [[SettingsLoader settings] language]);
    if([[SettingsLoader settings] language] == LMLanguageFrench){
        return [[self loadPlistValueOfKey:@"label-fr"] valueForKey:key];
    }
    return [[self loadPlistValueOfKey:@"label"] valueForKey:key];
}

-(NSString *)placeholderForKey:(NSString *)key
{
    
    DLog(@"langue placeholder: %d", [[SettingsLoader settings] language]);
    
    if([[SettingsLoader settings] language] == LMLanguageFrench){
        return [[self loadPlistValueOfKey:@"placeholder-fr"] valueForKey:key];
    }
    return [[self loadPlistValueOfKey:@"placeholder"] valueForKey:key];}







+(NSString *)resolutionToStringForResolution:(LMResolution)resolution
{
    NSString *file = [[NSBundle mainBundle] pathForResource:@"MultipleChoices" ofType:@"plist"];
    NSArray *resolutionChoice = [[NSDictionary dictionaryWithContentsOfFile:file] valueForKey:[@"Resolution-"  stringByAppendingString:[[NSLocale preferredLanguages] objectAtIndex:0]]];
        
    DLog(@"réso: %@", [resolutionChoice objectAtIndex:resolution]);
    
    return [resolutionChoice objectAtIndex:resolution];
}


@end
