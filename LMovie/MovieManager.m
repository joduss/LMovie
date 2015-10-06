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
@property (nonatomic, strong) NSDictionary *plist;
@end

@implementation MovieManager

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize allKey = _allKey;
@synthesize plist = _plist;
@synthesize keyOrderedBySection = _keyOrderedBySection;

-(id)init
{
    DLog(@"Initialisation of MovieManager");
    AppDelegate *appDel = [UIApplication sharedApplication].delegate;
    _managedObjectContext = appDel.managedObjectContext;
    _managedObjectModel = appDel.managedObjectModel;
    _persistentStoreCoordinator = appDel.persistentStoreCoordinator;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Movie" inManagedObjectContext:_managedObjectContext ];
    _allKey = [[entity propertiesByName] allKeys];
    [self plist]; //We access plist one time, so it is initialized;
    
    self = [super init];
    return self;
}



//Insert a movie describe with the given information and commit
- (void)insertMovieWithInformations:(NSDictionary *)info
{    
   // DLog(@"new movie inserted: %@", [newMovie description]);
    [self insertWithoutSavingMovieWithInformations:info];
    [self saveContext];
    
}

//Insert movie in the DB, but does not commit the changes (use when adding a lot of movie at the same time
// when importing for example)
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
    
    float tmdb_rate;
    if(! [info valueForKey:@"tmdb_rate"]){
        tmdb_rate = 0;
    }
    else{
        tmdb_rate = [[info valueForKey:@"tmdb_rate"] floatValue];
        DLog(@"MovieManager | tmdb_rate: %f", tmdb_rate);
    }
    
    
    
    newMovie.mini_picture = UIImagePNGRepresentation(mini_image);
    newMovie.big_picture = UIImagePNGRepresentation(big_image);
    
    newMovie.title = [info valueForKey:@"title"];
    newMovie.year = [nf numberFromString:[info valueForKey:@"year"] ];
    newMovie.duration = [nf numberFromString:[info valueForKey:@"duration"] ];
    newMovie.genre = [info valueForKey:@"genre"];
    newMovie.director = [info valueForKey:@"director"];
    newMovie.actors = [info valueForKey:@"actors"];
    newMovie.tmdb_rate = [NSNumber numberWithFloat:tmdb_rate];
    newMovie.tmdb_ID = [nf numberFromString:[info valueForKey:@"tmdb_ID"] ];
    
    newMovie.language = [info valueForKey:@"language"];
    newMovie.subtitle = [info valueForKey:@"subtitle"];
    newMovie.resolution = [nf numberFromString:[info valueForKey:@"resolution"]];
    newMovie.user_rate = [NSNumber numberWithInt:user_rate];
    newMovie.viewed = [nf numberFromString:[info valueForKey:@"viewed"] ];
    newMovie.comment = [info valueForKey:@"comment"];
    
    DLog(@"MovieManager | résultat de l'ajout Movie: %@", [newMovie description]);

    // DLog(@"new movie inserted: %@", [newMovie description]);
}


//Modifie the Movie Object with the new information given by the user
// TODO: modify information directly in the movie object, or create a mock object if not possible or find a better way
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
    
    float tmdb_rate;
    if(! [info valueForKey:@"tmdb_rate"]){
        tmdb_rate = 0;
    }
    else{
        tmdb_rate = [[info valueForKey:@"tmdb_rate"] floatValue];
        DLog(@"tmdb_rate enregistré: %f",tmdb_rate);
    }
    
    
    movieToModify.big_picture = UIImagePNGRepresentation(big_image);
    movieToModify.mini_picture = UIImagePNGRepresentation(mini_image);
    movieToModify.title = [info valueForKey:@"title"];
    movieToModify.year = [nf numberFromString:[info valueForKey:@"year"] ];
    movieToModify.duration = [nf numberFromString:[info valueForKey:@"duration"] ];
    movieToModify.genre = [info valueForKey:@"genre"];
    movieToModify.director = [info valueForKey:@"director"];
    movieToModify.actors = [info valueForKey:@"actors"];
    movieToModify.tmdb_rate = [NSNumber numberWithFloat:tmdb_rate];
    movieToModify.tmdb_ID = [nf numberFromString:[info valueForKey:@"tmdb_ID"] ];
    movieToModify.subtitle = [info valueForKey:@"subtitle"];
    movieToModify.language = [info valueForKey:@"language"];
    movieToModify.resolution = [nf numberFromString:[info valueForKey:@"resolution"]];
    movieToModify.user_rate = [NSNumber numberWithInt:user_rate];
    movieToModify.viewed = [nf numberFromString:[info valueForKey:@"viewed"] ];
    movieToModify.comment = [info valueForKey:@"comment"];

    
    [self saveContext];
    DLog(@"MovieManager | résultat de la modification de Movie: %@", [movieToModify description]);

    return movieToModify;
}



-(void)deleteMovie:(Movie *)movie{
    [_managedObjectContext deleteObject:movie];
}

//Commit
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



//autocomplete missing mandatory information
- (void)controlInfoDico:(NSMutableDictionary *)info
{
    if([info valueForKey:@"viewed"] == nil){
        [info setValue:[NSString stringWithFormat:@"%d", LMViewedUnknown] forKey:@"viewed"];
    }
    if([info valueForKey:@"resolution"] == nil){
        [info setValue:[NSString stringWithFormat:@"%d", LMResolutionUnknown] forKey:@"resolution"];
    }
}





#pragma mark - gestion des clé, de leur ordre, section associée etc / Handle keys, order and in which table view section they should be
/*
    On se base sur Keys.plist. Ce Plist définit le nom des clés (qui sont ceux définit dans CoreData), et on leur associe:
    - un ordre selon l'affichage que l'on veut dans nos TableView
    - une section
    - les placeholder (FR et EN) à mettre
    - les "labels" (FR et EN) (label: genre si on a "Sous-titre: FR, EN", Sous-titre et le label)
 */
/*
    A plist file is used to organise the MovieInfo table view. The plist states what information should be at which position in
    which section.
    It also specifies the placeholder text and the title for the labels
 */


//Retourne soit le dico de la section associée à une variable d'un film, soit de l'ordre


-(NSDictionary *)plist{
    //DLog(@"PLIST ACCESS");
    if(_plist == nil){
        NSString *file = [[NSBundle mainBundle] pathForResource:@"Keys" ofType:@"plist"];
        NSDictionary *dico = [NSDictionary dictionaryWithContentsOfFile:file];
        _plist = dico;
    }
    return _plist;
}


-(NSDictionary *)loadPlistValueOfKey:(NSString *)key
{
    //DLog(@"PLIST: %@", _plist);
    return [_plist valueForKey:key];
}

//Returns an array that specify the order of the information in the Table view
-(NSArray *)orderedKey
{
    return (NSArray *)[self loadPlistValueOfKey:@"order"];
}

//SREturns an array that specify in which section each information should be
-(NSArray *)keyOrderedBySection{
    if(_keyOrderedBySection == nil){
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
        
        _keyOrderedBySection = [indexPathOrdered copy];
    }
    return _keyOrderedBySection;

}

//Returns the KEY NAME (A key specify what kind it the information (title, year, duration, ratings, etc))
// at a given index path
-(NSString *)keyAtIndexPath:(NSIndexPath *)path
{
    return [[[self keyOrderedBySection] objectAtIndex:path.section] objectAtIndex:path.row];
}

//Returns in which section the key should be
-(int)sectionForKey:(NSString *)key{
    NSDictionary *dico = [self loadPlistValueOfKey:@"section"];
    return [[dico valueForKey:key] floatValue];
}

//Returns the label for a given key
-(NSString *)labelForKey:(NSString *)key
{
    DLog(@"langue label for key in MOVIEMANAGER: %@", [[SettingsLoader settings] language]);

    if([[[SettingsLoader settings] language] isEqualToString:@"fr"]){
        return [[self loadPlistValueOfKey:@"label-fr"] valueForKey:key];
    }
    return [[self loadPlistValueOfKey:@"label"] valueForKey:key];
}


//Returns the placeholder text for a given key
-(NSString *)placeholderForKey:(NSString *)key
{
    
    DLog(@"langue placeholder: %@", [[SettingsLoader settings] language]);
    
    if([[[SettingsLoader settings] language] isEqualToString:@"fr"]){
        return [[self loadPlistValueOfKey:@"placeholder-fr"] valueForKey:key];
    }
    return [[self loadPlistValueOfKey:@"placeholder"] valueForKey:key];
}






//Return the name associated to a LMResolution value
+(NSString *)resolutionToStringForResolution:(LMResolution)resolution
{
    NSString *file = [[NSBundle mainBundle] pathForResource:@"MultipleChoices" ofType:@"plist"];
    NSArray *resolutionChoice = [[NSDictionary dictionaryWithContentsOfFile:file] valueForKey:[@"Resolution-"  stringByAppendingString:[[NSLocale preferredLanguages] objectAtIndex:0]]];
        
    DLog(@"réso: %@", [resolutionChoice objectAtIndex:resolution]);
    
    return [resolutionChoice objectAtIndex:resolution];
}


@end
