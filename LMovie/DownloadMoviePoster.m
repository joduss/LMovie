//
//  DownloadMoviePoster.m
//  LMovieB
//
//  Created by Jonathan Duss on 17.02.13.
//
//

#import "DownloadMoviePoster.h"


@interface DownloadMoviePoster()
-(id)initDownloadMoviePoster;
@property (nonatomic, strong) MBProgressHUDOnTop *progressView;
@property (nonatomic, strong) MovieManager *movieManager;
@property (nonatomic)  BOOL stopImageCompletition;


@end


@implementation DownloadMoviePoster

-(id)init{
    [NSException raise:NSGenericException format:@"you can't init an object of this class. USE [DownloadMoviePoster downloadPosters]"];
    return nil;
}

-(id)initDownloadMoviePoster{
    self = [super init];
    
    _movieManager = [MovieManager instance];
    _progressView = [[MBProgressHUDOnTop alloc] initOnTop];
    _progressView.detailsLabelText = NSLocalizedString(@"Clic to stop KEY", @"");
    [_progressView setMinShowTime:2];


    _stopImageCompletition = NO;
    
    //Ajoute de l'action toucher la vue = stopper
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopPictureLoading:)];
    gesture.numberOfTapsRequired = 1;
    gesture.numberOfTouchesRequired = 1;
    //gesture.delegate = self;
    [_progressView addGestureRecognizer:gesture];
    
    
    
    
    return self;
}


+(void)downloadPosters{
    DownloadMoviePoster *downloader = [[DownloadMoviePoster alloc] initDownloadMoviePoster];
    [downloader downloadMoviePoster];
}



- (void)downloadMoviePoster
{
    
#warning  corriger l'état d'avancement qui disparait parfois avant
    
    
    //On get tous les films stockés
    NSManagedObjectContext *context = [_movieManager managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Movie" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    
    NSError *error = nil;
    NSArray *movies = [context executeFetchRequest:fetchRequest error:&error];
    if (movies == nil) {
        DLog(@"error lors du fetch dans Setting");
    }
    
    NSMutableArray *oa = [[NSMutableArray alloc] init];
    
    for(Movie *m in movies){
        [oa addObject:m.objectID];
    }
    
    DLog(@"oa: %@", [oa description]);
    
    
    //execute la recherche:
    
    
    __block int numberOfMovieProcessed = 0;
    __block int indexOfCurrentMovie = 0;
    
    if([movies count] > 0){
        
        //ProgressViewLabel
        [_progressView setLabelText:[NSString stringWithFormat:@"0/%d",[movies count]]];
        [_progressView showProgressAnimationOnTop];
        
        
        
        //DLog(@"w: %f, h:%f",_blackViewPictureLoading.frame.size.width, _blackViewPictureLoading.frame.size.height);
        
        
        //Lancement du processus de recherche d'image (et de TMDB rate) pour tous les films
        
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            while(indexOfCurrentMovie < [movies count] && [self stopImageCompletition] == NO){
                int try = 0;
                while((indexOfCurrentMovie - numberOfMovieProcessed) > MAX_DOWNLOADS && try < MAX_TRY_THREAD && [self stopImageCompletition] == NO){
                    DLog(@"plus que 3");
                    [NSThread sleepForTimeInterval:2];
                }
                try = 0;
                DLog(@"Nouveau Thread");
                int index = indexOfCurrentMovie;
                
                dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    
                    NSManagedObjectContext *ctx = [[NSManagedObjectContext alloc] init];
                    [ctx setPersistentStoreCoordinator:_movieManager.persistentStoreCoordinator];
                    
                    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
                    [nc addObserver:self
                           selector:@selector(mergeChanges:)
                               name:NSManagedObjectContextDidSaveNotification
                             object:ctx];
                    
                    DLog(@"oa plus tard: %@", [oa description]);
                    NSManagedObjectID *obId = [oa objectAtIndex:index];
                    
                    Movie *currentMovie = (Movie *)[ctx objectWithID:obId];
                    Cover *covers = (Cover *)currentMovie.cover;
                    NSData *coverData = covers.mini_cover;
                    NSData *defaultBigCoverData = [MovieManagerUtils defaultBigCoverData];
                    
                    
                    
                    //if([coverData isEqualToData:defaultBigCoverData]){
                        if(currentMovie.tmdb_ID != nil){
                            [self loadMoviePictureForMovieWithTMDB_ID:currentMovie];
                            [ctx save:nil];
                        }
                        else
                        {
                            [self loadMoviePictureForMovieWithoutTMDB_ID:currentMovie];
                            [ctx save:nil];
                        }
                    //}
                    numberOfMovieProcessed++;

                    dispatch_async( dispatch_get_main_queue(), ^{
                        //[_movieManager saveContext];
                        [_progressView setLabelText:[NSString stringWithFormat:@"%d/%d",numberOfMovieProcessed,[movies count]]];
                        float progress = (float)numberOfMovieProcessed / (float)[movies count];
                        [_progressView setProgress:progress];
                        if(progress == 1){
                            [_progressView hideProgressAnimationOnTop];
                        }
                        DLog(@"avancement: %f", progress );
                        DLog(@"numberOfMovieok: %d", numberOfMovieProcessed);
                        
                        if(progress == 1 && numberOfMovieProcessed == indexOfCurrentMovie){
                            [_progressView setProgress:1];
                            [_progressView setLabelText:[NSString stringWithFormat:@"%d/%d",[movies count],[movies count]]];
                            [_movieManager saveContext];
                            [_progressView hideProgressAnimationOnTop];
                        }
                    });
                });
                
                
                indexOfCurrentMovie ++;
                DLog(@"no de film traité: %d", indexOfCurrentMovie);
                
                
                
            }
        });
    }
    

    
    
}



-(void)loadMoviePictureForMovieWithTMDB_ID:(Movie *)movie
{
    NSURL *alternativeTitlesUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.themoviedb.org/3/movie/%@?api_key=%@", movie.tmdb_ID, TMDB_API_KEY]];
    int try = 0;
    while(try < MAX_TRY){
        @try {
            NSData *data = [NSData dataWithContentsOfURL:alternativeTitlesUrl];
            
            NSDictionary *dico = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            
            NSString *picturePath = [@"http://cf2.imgobject.com/t/p" stringByAppendingFormat:@"/w500%@?api_key=%@",[dico valueForKey:@"poster_path"],TMDB_API_KEY];
            
            //On crée l'image, enregistre en png via saveImage dans le dossier temporaire
            NSData *picData = [NSData dataWithContentsOfURL:[NSURL URLWithString:picturePath]];
            //UIImage *picture = [UIImage imageWithData:[NSData dataWithContentsOfURL:]];
            //NSString *pictureTempPath = [MovieManagerUtils saveImageInTemporaryDirectory:picture];
            //NSDictionary *movieInfos = [movie formattedInfoInDictionnaryWithImage:ImageSizeBig];
            //[movieInfos setValue:pictureTempPath forKey:@"big_picture_path"];
            
            
            //DLog(@"Cover avant: %@", cover.big_cover);
            [movie setCoversWithData:picData];
            
            //DLog(@"Cover après: %@", cover.big_cover);
            
            
            
            //on enregistre
            //[_movieManager modifyMovie:movie WithInformations:movieInfos];
            DLog(@"Image trouvée et enregistrée pour le film %@", [movie valueForKey:@"title"]);
            
        }
        @catch (NSException *exception) {
            DLog(@"Error, exception car data certainement null");
        }
        @finally {
            try++;
        }
    }
    
}


/*
 * 1. On cherche un film correspondant au titre, année de sortie sur TMDB
 * 2. On associe le TMDB_ID à ce film
 * 3. On lance la recherche d'image de ce film via la méthode loadMoviePictureForMovieWithTMDB_ID
 */
-(void)loadMoviePictureForMovieWithoutTMDB_ID:(Movie *)movie
{
    BOOL success = NO;
    NSDictionary *dico;
    int try = 0;
    
    //chargement du dico des résultats
    while(!success){
        @try {
            NSString *search = movie.title;
            search = [search stringByAppendingFormat:@" %@", movie.year];
            DLog(@"search: %@", search);
            
            
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.themoviedb.org/3/search/movie?api_key=%@&query=%@", TMDB_API_KEY, [search stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
            
            
            dico = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            success = YES;
            DLog(@"dico: %@", [dico description]);
        }
        @catch (NSException *exception) {
            try ++;
            DLog(@"castch");
            if(try > MAX_TRY){
                DLog(@"break");
                break;
            }
        }
    }
    
    //On traire selon succes ou non, et  selon résultat ou non
    if(success){
        NSMutableArray *moviesResults = [[dico valueForKey:@"results"] mutableCopy];
        
        DLog(@"movies Results: %@", [moviesResults description]);
        
        //enlève tous les films ayant une date différente ou un titre différent
        NSDictionary *currentInfos;
        int currentIndex = 0;
        
        while(currentIndex < [moviesResults count]){
            currentInfos = [moviesResults objectAtIndex:currentIndex];
            int releaseOfCurrentMovie = [movie.year intValue];
            
            
            NSArray *yearDecomposed;
            yearDecomposed = [[currentInfos valueForKey:@"release_date"] componentsSeparatedByString:@"-"];
            int year = [[yearDecomposed objectAtIndex:0] intValue];
            
            if(! [[currentInfos valueForKey:@"title"] isEqualToString:movie.title] || (releaseOfCurrentMovie != year) ){
                [moviesResults removeObjectAtIndex:currentIndex];
            }
            else{
                currentIndex++;
            }
        }
        if([moviesResults count] == 1){
            currentInfos = [moviesResults lastObject];
            
            //DLog(@"Image trouvée et enregistrée pour le film %@", [currentInfos valueForKey:@"title"]);
            //NSString *picturePath = [@"http://cf2.imgobject.com/t/p" stringByAppendingFormat:@"/w500%@?api_key=%@",[currentInfos valueForKey:@"poster_path"],TMDB_API_KEY];
            
            //on a trouvé un film correspondant. On l'associe donc au TMDB_ID et on relance la recherche d'image pour ce film
            [movie setTmdb_ID:[NSNumber numberWithInt:[[currentInfos valueForKey:@"id"] intValue] ]];
            [self loadMoviePictureForMovieWithTMDB_ID:movie];
            
        }
        
        
    }
    
    
}



-(void)stopPictureLoading:(UIGestureRecognizer *)gesture
{
    DLog(@"stopLoading PIcture");
    _stopImageCompletition = YES;
    [_progressView hideProgressAnimationOnTop];
}



- (void)mergeChanges:(NSNotification *)notification
{
    //ApplicationController *appController = [[NSApplication sharedApplication] delegate];
    NSManagedObjectContext *mainContext = _movieManager.managedObjectContext;
    
    // Merge changes into the main context on the main thread
    [mainContext performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:)
                                  withObject:notification
                               waitUntilDone:YES];
}




@end
