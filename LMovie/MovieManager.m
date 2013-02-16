//
//  MovieManager.m
//  LMovie
//
//  Created by Jonathan Duss on 06.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovieManager.h"





@interface MovieManager ()
- (void)controlInfoDico:(NSMutableDictionary *)info;
@end

@implementation MovieManager

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize tempContext = _tempContext;

static MovieManager *_movieManager;

/*
-(Movie *)backupMovie:(Movie *)movie{
    [_managedObjectContext re]
}*/

+(MovieManager *)instance{
    @synchronized(self) {
        if( !_movieManager){
            _movieManager = [[MovieManager alloc] init];
        }
        return _movieManager;
    }
}


-(id)init
{
    DLog(@"Initialisation of MovieManager");
    AppDelegate *appDel = [UIApplication sharedApplication].delegate;
    _managedObjectContext = appDel.managedObjectContext;
    _managedObjectModel = appDel.managedObjectModel;
    _persistentStoreCoordinator = appDel.persistentStoreCoordinator;
    _tempContext = [[NSManagedObjectContext alloc] init];
    [_tempContext setPersistentStoreCoordinator:_persistentStoreCoordinator];
    
    //NSEntityDescription *entity = [NSEntityDescription entityForName:@"Movie" inManagedObjectContext:_managedObjectContext ];
    //_allKey = [[entity propertiesByName] allKeys];
     //We access plist one time, so it is initialized;
    
    self = [super init];
    return self;
}




- (Movie *)insertNewMovieWithTitle:(NSString *)title genre:(NSString *)genre year:(NSNumber *)year director:(NSString *)director picture:(NSData *)picture actors:(NSString *)actors duration:(NSNumber *)duration language:(NSString *)language subtitle:(NSString *)subtitle userRate:(NSNumber *)userRate tmdbRate:(NSNumber *)tmdbRate viewed:(BOOL)viewed comment:(NSString *)comment
{

    NSLog(@"ERREUR, ERREUR ERREUR");
    
    return nil;
}


/*
- (void)insertMovieWithInformations:(NSDictionary *)info
{    
   // DLog(@"new movie inserted: %@", [newMovie description]);
    [self insertWithoutSavingMovieWithInformations:info];
    [self saveContext];
    
}*/


-(Movie *)newMovie{
    Movie *movie = (Movie *)[NSEntityDescription insertNewObjectForEntityForName:@"Movie" inManagedObjectContext:_managedObjectContext];
    Cover *cover = (Cover *)[NSEntityDescription insertNewObjectForEntityForName:@"Cover" inManagedObjectContext:_managedObjectContext];

    [movie setCover:cover];
    
    DLog(@"MOVIE TEMP: %@", [movie description]);
    return movie;
}

/*
-(void)storeMovie:(Movie *)movie{
    //[_tempContext save:nil];
    [_tempContext deleteObject:movie];
    [_tempContext deleteObject:movie.cover];

    DLog(@"%@", [movie.cover description]);
    
    //[_tempContext save:nil];
    //[_managedObjectContext insertObject:movie.cover];
    [_managedObjectContext insertObject:movie];
    //[_managedObjectContext insertObject:movie.cover];
    [self saveContext];
}*/




//Method utilisée par SettingTVC lors de l'import
- (void)insertWithoutSavingMovieWithInformations:(NSDictionary *)infoAboutMovie
{
    NSMutableDictionary *info = [infoAboutMovie mutableCopy];
    [self controlInfoDico:info];

    Movie* newMovie = (Movie *)[NSEntityDescription insertNewObjectForEntityForName:@"Movie" inManagedObjectContext:_managedObjectContext];
    DLog(@"info: %@", [info description]);
    
    
    /*traitement pour l'image:
     *
     * On reçoit uniquement une URL vers l'image stocké dans le dossier temporaire. Il faut encore qu'on la traite et enregistre dans des résolutions définies
     */
    //UIImage *originalImage = [info valueForKey:@"big_picture"];
    
    
    //UIImage *mini_image = [utilities resizeImageToMini:originalImage];
    //UIImage *big_image = [utilities resizeImageToBig:originalImage];
    
    Cover *newCover = (Cover *)[NSEntityDescription insertNewObjectForEntityForName:@"Cover" inManagedObjectContext:_managedObjectContext
                                ];
    
    [newMovie setCover:newCover];
    
    //NSString *mini_image_path = [MovieManagerUtils saveImage:mini_image];
    //NSString *big_image_path = [MovieManagerUtils saveImage:big_image];
    
    
    
    
    
    
    
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
    
    
    
    Cover *cover = (Cover *) newMovie.cover;
    //cover.big_cover = big_image;
    //cover.mini_cover = mini_image;
    
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
    //[newMovie verifyData];
}



//-(Movie *)modifyMovie:(Movie *)movie WithInformations:(NSDictionary *)infoAboutMovie
//{
//    Movie *movieToModify = movie;
//    
//#warning UPDATER CA AUSSI POUR LES IMAGES
//    //DLog(@"tmdb_rate: %@", [info valueForKey:@"tmdb_rate"]);
//    NSMutableDictionary *info = [infoAboutMovie mutableCopy];
//    DLog(@"MovieManager | Mise à jour de Movie avec ces nouvelles info: %@", [info description]);
//    
//    
//    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
//    
//    /*traitement pour l'image:
//     *
//     * Si l'image n'a pas changée, on ne fait rien, sinon:
//     * On reçoit uniquement une URL vers l'image stocké dans le dossier temporaire. Il faut encore qu'on la traite et enregistre dans des résolutions définies
//     */
//    
//    NSString *mini_image_path;
//    NSString *big_image_path;
//    /*
//    if([[info valueForKey:@"big_picture_path"] isEqualToString:movie.big_picture_path] == NO){
//        UIImage *originalImage = [MovieManagerUtils loadImageAtPath:[info valueForKey:@"big_picture_path"]];
//        
//        UIImage *mini_image = [utilities resizeImageToMini:originalImage];
//        UIImage *big_image = [utilities resizeImageToBig:originalImage];
//        
//        mini_image_path = [MovieManagerUtils saveImage:mini_image];
//        big_image_path = [MovieManagerUtils saveImage:big_image];
//    } else {
//        mini_image_path = movie.mini_picture_path;
//        big_image_path = movie.big_picture_path;
//    }
//    
//    int user_rate;
//    if(! [info valueForKey:@"user_rate"]){
//        user_rate = 0;
//    }
//    else{
//        user_rate = [[info valueForKey:@"user_rate"] intValue];
//    }
//    
//    float tmdb_rate;
//    if(! [info valueForKey:@"tmdb_rate"]){
//        tmdb_rate = 0;
//    }
//    else{
//        tmdb_rate = [[info valueForKey:@"tmdb_rate"] floatValue];
//        DLog(@"tmdb_rate enregistré: %f",tmdb_rate);
//    }
//    
//    
//    movieToModify.mini_picture_path = mini_image_path;
//    movieToModify.big_picture_path = big_image_path;
//    movieToModify.title = [info valueForKey:@"title"];
//    movieToModify.year = [nf numberFromString:[info valueForKey:@"year"] ];
//    movieToModify.duration = [nf numberFromString:[info valueForKey:@"duration"] ];
//    movieToModify.genre = [info valueForKey:@"genre"];
//    movieToModify.director = [info valueForKey:@"director"];
//    movieToModify.actors = [info valueForKey:@"actors"];
//    movieToModify.tmdb_rate = [NSNumber numberWithFloat:tmdb_rate];
//    movieToModify.tmdb_ID = [nf numberFromString:[info valueForKey:@"tmdb_ID"] ];
//    movieToModify.subtitle = [info valueForKey:@"subtitle"];
//    movieToModify.language = [info valueForKey:@"language"];
//    movieToModify.resolution = [nf numberFromString:[info valueForKey:@"resolution"]];
//    movieToModify.user_rate = [NSNumber numberWithInt:user_rate];
//    movieToModify.viewed = [nf numberFromString:[info valueForKey:@"viewed"] ];
//    movieToModify.comment = [info valueForKey:@"comment"];
//
//    
//    [self saveContext];
//    DLog(@"MovieManager | résultat de la modification de Movie: %@", [movieToModify description]);
//
//    [movieToModify verifyData];
//    return movieToModify;
//     
//     */
//    
//    return movieToModify;
//}



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




- (void)controlInfoDico:(NSMutableDictionary *)info
{
    if([info valueForKey:@"viewed"] == nil){
        [info setValue:[NSString stringWithFormat:@"%d", LMViewedUnknown] forKey:@"viewed"];
    }
    if([info valueForKey:@"resolution"] == nil){
        [info setValue:[NSString stringWithFormat:@"%d", LMResolutionUnknown] forKey:@"resolution"];
    }
}



















@end
