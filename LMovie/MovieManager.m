//
//  MovieManager.m
//  LMovie
//
//  Created by Jonathan Duss on 06.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovieManager.h"



@implementation MovieManager

//@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;






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

- (Movie *)newMovieWithTitle:(NSString *)title genre:(NSString *)genre year:(NSNumber *)year director:(NSString *)director picture:(NSData *)picture actors:(NSString *)actors duration:(NSNumber *)duration language:(NSString *)language subtitle:(NSString *)subtitle userRate:(NSNumber *)userRate tmdbRate:(NSNumber *)tmdbRate viewed:(BOOL)viewed comment:(NSString *)comment
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




/*-(void)insertNewMovie:(MyMovie *)movie
{
    NSManagedObjectContext *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Movie" inManagedObjectContext:self.managedObjectContext];
    
    NSDictionary *info = movie.getAllInfo;
    
    for (NSString *key in [info allKeys]) {
        [newManagedObject setValue:[info valueForKey:key] forKey:key];
    }
}*/




@end
