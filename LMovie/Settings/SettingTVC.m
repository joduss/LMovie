//
//  SettingTVC.m
//  LMovie
//
//  Created by Jonathan Duss on 09.08.12.
//
//

#import "SettingTVC.h"
#import "MBProgressHUD.h"


@interface SettingTVC ()
@property MBProgressHUD *progressView;
@property (nonatomic)  BOOL stopImageCompletition;
@property (nonatomic, strong) UIView *blackViewPictureLoading;
@end

@implementation SettingTVC
@synthesize appLanguageChooser = _appLanguageChooser;
@synthesize importCell;
@synthesize downloadMoviePosterCell = _downloadMoviePosterCell;
@synthesize exportCell = _exportCell;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Settings KEY",@"Titre de la fenêtre settings");
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIBarButtonItem *okButton = [[UIBarButtonItem alloc] initWithTitle:@"Ok" style:UIBarButtonItemStylePlain target:self action:@selector(okButtonPressed:)];
    self.navigationItem.leftBarButtonItem = okButton;
    [_appLanguageChooser addTarget:self action:@selector(AppLanguageChanged) forControlEvents:UIControlEventValueChanged];
    
    UILabel *appLanguageLabel = (UILabel *)[self.appLanguageCell viewWithTag:100];
    UILabel *downloadMoviePosterLabel = (UILabel *)[self.downloadMoviePosterCell viewWithTag:100];
    UILabel *importLabel = (UILabel *)[self.importCell viewWithTag:100];
    UILabel *exportLabel = (UILabel *)[self.exportCell viewWithTag:100];
    appLanguageLabel.text = NSLocalizedString(@"App Language KEY", @"");
    downloadMoviePosterLabel.text = NSLocalizedString(@"Download Poster KEY", @"");
    importLabel.text = NSLocalizedString(@"import KEY", @"");
    exportLabel.text = NSLocalizedString(@"export KEY", @"");
    
    int langueChoix;
    if([[[SettingsLoader settings] language] isEqualToString:@"en"]){
         langueChoix = 0;
    }
    else{
        langueChoix = 1;
    }
    
    [self.appLanguageChooser setSelectedSegmentIndex:langueChoix];

    
    
}



- (void)viewDidUnload
{
    [self setAppLanguageCell:nil];
    [super viewDidUnload];
    [self setExportCell:nil];
    [self setImportCell:nil];
    [self setDownloadMoviePosterCell:nil];
    [self setAppLanguageChooser:nil];
    [self setBlackViewPictureLoading:nil];
    [self setProgressView:nil];
    [self setAppLanguageChooser:nil];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}





-(IBAction)okButtonPressed:(id)sender
{
    
    [self dismissModalViewControllerAnimated:YES];
}









#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(cell == self.importCell || cell == self.exportCell){
        
        if(cell == self.importCell){
            DLog(@"import cell");
            _progressView.labelText = NSLocalizedString(@"Importing KEY",@"");
            [[[ImportExport alloc] init] import];
        }
        else if (cell == self.exportCell){
            DLog(@"export cell");
            _progressView.labelText = NSLocalizedString(@"Exporting KEY",@"");
            [[[ImportExport alloc] init] export];
        }
    }
    else if (cell == self.downloadMoviePosterCell){
        DLog(@"downloadMoviePosterCell pressed");
        [self downloadMoviePoster];
    }
    
    
    [cell setSelected:NO animated:YES];
}



- (void)downloadMoviePoster
{
#warning pas complet: ajouter état d'avancement
    [self setStopImageCompletition:NO];
    
    
    
    
    //Obscurci l'arrière (je crois)
    CGRect winFrame =       [self parentViewController].view.bounds;
    
    _blackViewPictureLoading = [[UIView alloc] initWithFrame:winFrame];
    _blackViewPictureLoading.alpha = 0;
    [_blackViewPictureLoading setHidden:NO];
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    [window bringSubviewToFront:_blackViewPictureLoading];
    [_blackViewPictureLoading setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
    [[self parentViewController].view addSubview:_blackViewPictureLoading];
    [UIView animateWithDuration:0.3 animations:^{
        [_blackViewPictureLoading setAlpha:1];
    }];
    
    //Ajoute de l'action toucher la vue = stopper
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopPictureLoading:)];
    gesture.numberOfTapsRequired = 1;
    gesture.numberOfTouchesRequired = 1;
    //gesture.delegate = self;
    [_blackViewPictureLoading addGestureRecognizer:gesture];
    
    
    
    
    
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
    
    
    //execute la recherche:

    
    __block int numberMovieOk = 0;
    __block int indexMovieUsed = 0;
    
    if([movies count] > 0){
        
        //initialisation ProgressView
        [self setProgressView:nil];
        _progressView = [[MBProgressHUD alloc] initWithView:_blackViewPictureLoading];
        [_progressView setMode:MBProgressHUDModeDeterminate];
        [_progressView addGestureRecognizer:gesture];
        [_progressView setOpacity:1];
        [_blackViewPictureLoading addSubview:_progressView];
        [window bringSubviewToFront:_progressView];
        [_progressView show:YES];
        [_progressView setMinShowTime:2];
        [_progressView setProgress:0];
        [_progressView setLabelText:[NSString stringWithFormat:@"0/%d",[movies count]]];
        _progressView.detailsLabelText = NSLocalizedString(@"Clic to stop KEY", @"");
        
        
        
        //DLog(@"w: %f, h:%f",_blackViewPictureLoading.frame.size.width, _blackViewPictureLoading.frame.size.height);
        
        //Lancement du processus de recherche d'image (et de TMDB rate) pour tous les films
        
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            while(indexMovieUsed < [movies count] && [self stopImageCompletition] == NO){
                int try = 0;
                while((indexMovieUsed - numberMovieOk) > MAX_DOWNLOADS && try < MAX_TRY_THREAD && [self stopImageCompletition] == NO){
                    DLog(@"plus que 3");
                    [NSThread sleepForTimeInterval:2];
                }
                try = 0;
                DLog(@"Nouveau Thread");
                int index = indexMovieUsed;
                
                dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    Movie *currentMovie = [movies objectAtIndex:index];
                    Cover *covers = (Cover *)currentMovie.cover;
                    NSData *coverData = covers.mini_cover;
                    NSData *defaultBigCoverData = [MovieManagerUtils defaultBigCoverData];

                    
                    //if([coverData isEqualToData:defaultBigCoverData]){
                        if(currentMovie.tmdb_ID != nil){
                            [self loadMoviePictureForMovieWithTMDB_ID:currentMovie];
                        }
                        else
                        {
                            [self loadMoviePictureForMovieWithoutTMDB_ID:currentMovie];
                        }
                    //}
                    
                    dispatch_async( dispatch_get_main_queue(), ^{
                        numberMovieOk++;
                        //[_movieManager saveContext];
                        [_progressView setLabelText:[NSString stringWithFormat:@"%d/%d",numberMovieOk,[movies count]]];
                        float progress = (float)numberMovieOk / (float)[movies count];
                        [_progressView setProgress:progress];
                        if(progress == 1){
                            [_progressView hide:YES];
                            //[MBProgressHUD hideHUDForView:_blackViewPictureLoading animated:YES];
                            //_progressView = nil;
                            if(_blackViewPictureLoading != nil){
                                [UIView animateWithDuration:0.3 animations:^{ _blackViewPictureLoading.alpha = 0;
                                } completion:^(BOOL complet){
                                    _blackViewPictureLoading = nil;
                                }];
                            }
                        }
                        DLog(@"avancement: %f", progress );
                        DLog(@"numberOfMovieok: %d", numberMovieOk);
                    });
                });
                
                
                indexMovieUsed ++;
                DLog(@"no de film traité: %d", indexMovieUsed);
                
                
                
            }
        });
    }
    
[_movieManager saveContext];

    
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
            
            Cover *cover = movie.cover;
            
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
    [UIView animateWithDuration:0.3 animations:^{ _blackViewPictureLoading.alpha = 0;
    } completion:^(BOOL complet){
        _blackViewPictureLoading = nil;
    }];
}







-(void)AppLanguageChanged
{
    DLog(@"User a changé de langue en cliquant");
    SettingsLoader *s = [SettingsLoader settings];
    int choix = [self.appLanguageChooser selectedSegmentIndex];
    
    switch (choix) {
        case 0:
            [s setLanguage:@"en"];
            break;
        case 1:
            [s setLanguage:@"fr"];
            break;
        default:
            [s setLanguage:@"en"];
            break;
    }
    
    
    
    
}





@end
