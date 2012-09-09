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
@property (nonatomic) BOOL stopImageCompletition;
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
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIBarButtonItem *okButton = [[UIBarButtonItem alloc] initWithTitle:@"Ok" style:UIBarButtonItemStylePlain target:self action:@selector(okButtonPressed:)];
    self.navigationItem.leftBarButtonItem = okButton;
    [_appLanguageChooser addTarget:self action:@selector(AppLanguageChanged) forControlEvents:UIControlEventValueChanged];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *language = [defaults valueForKey:@"language"];
    [_appLanguageChooser setSelectedSegmentIndex:[language intValue]];
    
}



- (void)viewDidUnload
{
    [self setExportCell:nil];
    [self setImportCell:nil];
    [self setDownloadMoviePosterCell:nil];
    [self setAppLanguageChooser:nil];
    [super viewDidUnload];
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
        _progressView = [[MBProgressHUD alloc] initWithView:self.view];
        [_progressView setMode:MBProgressHUDModeDeterminate];
        _progressView.labelText = NSLocalizedString(@"Importing KEY",@"");
        [self.view addSubview:_progressView];
        [_progressView showUsingAnimation:YES];
        [_progressView setMinShowTime:1];
        
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            // Show the HUD in the main tread
            
            // Do a taks in the background
            if(cell == self.importCell){
                DLog(@"import cell");
                [self import];
            }
            else if (cell == self.exportCell){
                DLog(@"export cell");
                [self export];
            }
            
            
            // Hide the HUD in the main tread
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                _progressView = nil;
            });
        });
    }
    else if (cell == self.downloadMoviePosterCell){
        DLog(@"downloadMoviePosterCell pressed");
        [self downloadMoviePoster];
    }
    
    
    [cell setSelected:NO animated:YES];
}




- (void)export{
    
    NSManagedObjectContext *context = [_movieManager managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Movie"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSArray *movies = [context executeFetchRequest:request error:nil];
    
    NSString *string = @"";
    NSDate *date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'-'HH'h'mm'm'ss's'"];
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:~ NSTimeZoneCalendarUnit fromDate:[NSDate date]];
    date = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
    
    NSString *fileName = [[NSLocalizedString(@"ExportedMovies KEY",@"") stringByAppendingString:[dateFormatter stringFromDate:date ]] stringByAppendingString:@".txt"];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    [string writeToFile:filePath atomically:TRUE encoding:NSUTF8StringEncoding error:NULL];
    NSFileHandle *fileHandler = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
    
    
    
    
    
    DLog(@"fichier écrit vers: %@", filePath);
    float percentDonePerMovie = 1.0/[movies count];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_progressView setDetailsLabelText:[NSString stringWithFormat:@"%d movies", [movies count]]];
    });
    
    NSMutableArray *keys = [[_movieManager orderedKey] mutableCopy];
    [keys removeObjectAtIndex:0];
    
    for(Movie *movie in movies){
        string = @"";
        for(NSString *key in keys){
            NSString *info = [[movie valueForKey:key] description];
            if(!info){
                info = @"";
            }
            if([key isEqualToString:@"viewed"]){
                int a = [info intValue];
                switch (a) {
                    case 0:
                        info = @"✕";
                        break;
                    case 1:
                        info = @"✓";
                        break;
                    default:
                        info = @"?";
                        break;
                }
            }
            string = [string stringByAppendingString:info];
            //DLog(@"info: %@", [[movie valueForKey:key] description]);
            //DLog(@"string: %@", string);
            string = [string stringByAppendingString:@"\t"];
        }
        string = [string stringByAppendingString:@"\n"];
        //[string writeToFile:filePath atomically:TRUE encoding:NSUTF8StringEncoding error:NULL];
        [fileHandler seekToEndOfFile];
        [fileHandler writeData:[string dataUsingEncoding:NSUTF8StringEncoding]];
        dispatch_async(dispatch_get_main_queue(), ^{
            _progressView.progress = _progressView.progress + percentDonePerMovie;
        });
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        _progressView.progress = 1;
    });
    [fileHandler closeFile];
    //DLog(@"string: %@", string);
    
    // [self dismissModalViewControllerAnimated:YES];
}

- (void)import
{
    
    DLog(@"Import ok, Début de l'import");
    //NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *file = [path stringByAppendingString:@"/movies.txt"];
    
    NSString *fileContent;
    
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:file]){
        DLog(@"ERROR: file does not exists for import");
        DLog(@"chemin: %@",file);
    }
    else{
        NSError *error;
        //NSStringEncoding enc = 0;
        //fileContent = [NSString stringWithContentsOfFile:fileContent usedEncoding:NULL error:&error];
        fileContent = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:&error];
        //DLog(@"file exist with encoding: %d: \n %@", enc,fileContent);
        if(error){
            DLog(@"error lecture fichier: %@", [error localizedDescription]);
        }
        
    }
    
    //décomposition: 1 ligne du tableau = 1 film
    NSArray *movies = [fileContent  componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    float percentsPerMovie = 1.0/[movies count];
    float now = 0;
    
    //affiche le nombre de films en train d'être importés
    dispatch_async(dispatch_get_main_queue(), ^{
        [_progressView setDetailsLabelText:[NSString stringWithFormat:@"%d movies", [movies count]]];
        _progressView.minShowTime = 2;
    });
    
    
    //DLog(@"%d movies in txt: %@", [movies count],[movies description]);
    for(NSString *movie in movies){
        //DLog(@"movie : |%@|", movie);
        if(![movie isEqualToString:@"\n"] && ![movie isEqualToString:@""]){
            NSArray *movieInfo = [movie componentsSeparatedByString:@"\t"];
            int i = 0;
            NSMutableDictionary *infoForNewMovie = [[NSMutableDictionary alloc] init];
            
            
            //on supprime la clé "big_picture" car pas besoin
            NSMutableArray *keys = [[_movieManager orderedKey] mutableCopy];
            [keys removeObjectAtIndex:0];
            
            for(NSString *key in keys){
                NSString *info = [movieInfo objectAtIndex:i];
                [infoForNewMovie setValue:info forKey:key];
                ++i;
            }
            //DLog(@"DICO DES INFO: %@", [infoForNewMovie description]);
            if([[infoForNewMovie valueForKey:@"viewed"] isEqualToString:@"✕"]){
                [infoForNewMovie setValue:@"0" forKey:@"viewed"];
            }
            else if([[infoForNewMovie valueForKey:@"viewed"] isEqualToString:@"✓"]){
                [infoForNewMovie setValue:@"1" forKey:@"viewed"];
            }
            else if([[infoForNewMovie valueForKey:@"viewed"] isEqualToString:@"?"]){
                [infoForNewMovie setValue:@"2" forKey:@"viewed"];
            }
            else
            {
                [infoForNewMovie setValue:@"2" forKey:@"viewed"];
            }
            [_movieManager insertWithoutSavingMovieWithInformations:infoForNewMovie];
            
            
            //NSLog(@"dehors2 %@", [NSThread currentThread]);
            now = now + percentsPerMovie;
            dispatch_async(dispatch_get_main_queue(), ^{
                //NSLog(@" dedans 2%@", [NSThread currentThread]);
                //NSLog(@"%f", _progressView.progress);
                _progressView.progress = now;
            });
            //NSLog(@"now: %f", now-_progressView.progress);
            
        }
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _progressView.progress = 1;
    });
    //DLog(@"Import ok, sauvegarde du contexte demandé");
    //[_movieManager saveContext];
    
    
    //[self dismissModalViewControllerAnimated:YES];
}






- (void)downloadMoviePoster
{
#warning pas complet: ajouter état d'avancement
    int numberPages = 0;
    int numberResults = 0;
    [self setStopImageCompletition:NO];
    
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
    NSMutableArray *json = [[NSMutableArray alloc] init];
    NSDictionary *dico;
    BOOL success = NO;
    int try = 0;
    
    int numberMovieOk = 0;
    
    while(numberMovieOk < [movies count] && [self stopImageCompletition] == NO){
        
        DLog(@"no de film traité: %d", numberMovieOk);
        Movie *currentMovie = [movies objectAtIndex:numberMovieOk];
        
        if(currentMovie.big_picture == nil){
            if(currentMovie.tmdb_ID != nil){
                [self loadMoviePictureForMovieWithTMDB_ID:currentMovie];
            }
            else
            {
                [self loadMoviePictureForMovieWithoutTMDB_ID:currentMovie];
            }
        }
    numberMovieOk++;
        
    }
}



-(void)loadMoviePictureForMovieWithTMDB_ID:(Movie *)movie
{
    NSURL *alternativeTitlesUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.themoviedb.org/3/movie/%@?api_key=%@", movie.tmdb_ID, TMDB_API_KEY]];
    NSData *data = [NSData dataWithContentsOfURL:alternativeTitlesUrl];
    
    NSDictionary *dico = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    NSString *picturePath = [@"http://cf2.imgobject.com/t/p" stringByAppendingFormat:@"/w500%@?api_key=%@",[dico valueForKey:@"poster_path"],TMDB_API_KEY];
    UIImage *picture = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:picturePath]]];
    
    [movie setPicturesWithBigPicture:picture];
    
}


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
            
            DLog(@"Image trouvée et enregistrée pour le film %@", [currentInfos valueForKey:@"title"]);
            NSString *picturePath = [@"http://cf2.imgobject.com/t/p" stringByAppendingFormat:@"/w500%@?api_key=%@",[currentInfos valueForKey:@"poster_path"],TMDB_API_KEY];
            [movie setTmdb_ID:[NSNumber numberWithInt:[[currentInfos valueForKey:@"id"] intValue] ]];
            [self loadMoviePictureForMovieWithTMDB_ID:movie];
            
        }
        
        
    }


}










-(void)AppLanguageChanged
{
    DLog(@"User a changé de langue en cliquant");
    SettingsLoader *s = [SettingsLoader settings];
    [s changeAppLanguageToLanguage:[self.appLanguageChooser selectedSegmentIndex]];
    
}










@end
