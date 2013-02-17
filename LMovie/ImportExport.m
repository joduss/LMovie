//
//  ImportExport.m
//  LMovieB
//
//  Created by Jonathan Duss on 16.02.13.
//
//

#import "ImportExport.h"


@interface ImportExport ()
@property MBProgressHUDOnTop *progressView;
@property MovieManager *movieManager;
//@property UIView *blackBackGroud;
//@property UIViewController *topVC;
//@property UIWindow *window;
@end


@implementation ImportExport




-(id)init{
    self = [super init];
    _movieManager = [MovieManager instance];
    _progressView = [[MBProgressHUDOnTop alloc] initOnTop];
//    _topVC = [[UIApplication sharedApplication].keyWindow topMostController];
//    _window = [UIApplication sharedApplication].keyWindow;
    return self;
}

//-(void)showProgressAnimationOnTop{
//    
//    
//    
//    
//    CGRect winFrame = _topVC.view.bounds;
//    
//    //DLog(@"Background: %f, %f", winFrame.size.height, winFrame.size.width);
//    
//    _blackBackGroud = [[UIView alloc] initWithFrame:winFrame];
//    _blackBackGroud.alpha = 0.0;
//    [_blackBackGroud setHidden:NO];
//    [_topVC.view addSubview:_blackBackGroud];
//    [_topVC.view bringSubviewToFront:_blackBackGroud];
//    [_blackBackGroud setHidden:NO];
//    [_blackBackGroud setBackgroundColor:[UIColor blackColor]];
//    
//    [UIView animateWithDuration:0.5 animations:^{
//        [_blackBackGroud setAlpha:0.5];
//    }];
//    
//    
//    
//    _progressView = [[MBProgressHUD alloc]initWithWindow:[UIApplication sharedApplication].keyWindow];
//    [_topVC.view addSubview:_progressView];
//    
//    
//    [_progressView setMode:MBProgressHUDModeDeterminate];
//    [_progressView show:YES];
//    [_progressView setMinShowTime:1];
//}
//
//-(void)hideProgressAnimationOnTop{
//    [_progressView hide:YES];
//        
//    [UIView animateWithDuration:0.5 animations:^{
//        [_blackBackGroud setAlpha:0];
//    } completion:^(BOOL finished){
//        [_blackBackGroud removeFromSuperview];
//    }];
//    
//    
//}



-(void)import{
    [_progressView showProgressAnimationOnTop];
    _progressView.labelText = NSLocalizedString(@"Importing KEY",@"");
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Show the HUD in the main tread
        
        // Do a taks in the background
        [self importProcedure];
        
        // Hide the HUD in the main tread
        dispatch_async(dispatch_get_main_queue(), ^{
            //[MBProgressHUD hideHUDForView:self.view animated:YES];
            [_progressView hideProgressAnimationOnTop];
        });
    });
}

-(void)export{
    [_progressView showProgressAnimationOnTop];
    _progressView.labelText = NSLocalizedString(@"Exporting KEY",@"");
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Show the HUD in the main tread
        
        // Do a taks in the background
        [self exportProcedure];
        
        // Hide the HUD in the main tread
        dispatch_async(dispatch_get_main_queue(), ^{
            //[MBProgressHUD hideHUDForView:self.view animated:YES];
            [_progressView hideProgressAnimationOnTop];
        });
    });
}




- (void)importProcedure
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
    float progress = 0;
    
    
    
    //affiche le nombre de films en train d'être importés
    dispatch_async(dispatch_get_main_queue(), ^{
        [_progressView setDetailsLabelText:[NSString stringWithFormat:@"%d movies", [movies count]]];
        _progressView.minShowTime = 2;
    });
    
    
    //DLog(@"%d movies in txt: %@", [movies count],[movies description]);
    for(NSString *movie in movies){
        DLog(@"movie : |%@|", movie);
        if(![movie isEqualToString:@"\n"] && ![movie isEqualToString:@""]){
            
            Movie *movieToCreate = [_movieManager newMovie];
            
            //On sépare chaque "champs" séparé par une tabulation, présent sur une ligne du txt.
            NSMutableArray *movieInfo = [[movie componentsSeparatedByString:@"\t"] mutableCopy];
            [movieInfo removeLastObject];
            NSMutableDictionary *OrderedInfoForNewMovie = [[NSMutableDictionary alloc] init];
            
            
            //on supprime la clé "big_picture" car pas besoin
            NSMutableArray *keys = [[MovieManagerUtils orderedKey] mutableCopy];
            [keys removeObjectAtIndex:0];
            [keys addObject:@"tmdb_ID"];
            if([keys count] != [movieInfo count]){
                [keys removeLastObject];
            }
            
            //recontrole le nombre de valeur en fonction du nombre de clé. Si à nouveau pas =: on abandonne.
            if([keys count] == [movieInfo count]){
                //on rempli le dico d'info avec les clé et les info
                for(int i = 0; i < [keys count]; i++){
                    [OrderedInfoForNewMovie setObject:[movieInfo objectAtIndex:i] forKey:[keys objectAtIndex:i]];
                }
                
                
                //COVER
                Cover *cover = (Cover *)movieToCreate.cover;
                [cover setMini_cover:[MovieManagerUtils defaultMiniCoverData]];
                [cover setBig_cover:[MovieManagerUtils defaultBigCoverData]];
                
                
                //AUTRE
                NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Movie" inManagedObjectContext:_movieManager.managedObjectContext];
                NSDictionary *propDesc = [entityDesc attributesByName];
                for(NSString *key in keys){
                    
                    NSAttributeType attributeType = [[propDesc valueForKey:key] attributeType];
                    
                    //DLog(@"proptype: %@", [propType ]);
                    
                    switch (attributeType) {
                        case NSInteger16AttributeType:
                        case NSInteger32AttributeType:
                        case NSInteger64AttributeType:
                        case NSFloatAttributeType:
                        case NSDoubleAttributeType:
                        case NSDecimalAttributeType:
                            [movieToCreate setValue:[[OrderedInfoForNewMovie valueForKey:key] nsNumber] forKey:key];
                            break;
                        case NSStringAttributeType:
                            [movieToCreate setValue:[OrderedInfoForNewMovie valueForKey:key] forKey:key];
                            break;
                        default:
                            DLog(@"KEY: %@ -> est de classe %@", key, [[movieToCreate valueForKey:key] class]);
                            break;
                    }

//                    if(propType == NSInteger16AttributeType || propType){
//                        
//                        DLog(@"KEY: %@ -> NSNumber", key);
//                        
//                    } else if ([[movieToCreate valueForKey:key] isKindOfClass:[NSString class]]) {
//                        
//                        DLog(@"KEY: %@ -> STRING", key);
//                    } else {
//                        
//                    }

                }
                
                //VIEWED
                if([[OrderedInfoForNewMovie valueForKey:@"viewed"] isEqualToString:@"✕"]){
                    movieToCreate.viewed = [NSNumber numberWithInt:LMViewedNO];
                }
                else if([[OrderedInfoForNewMovie valueForKey:@"viewed"] isEqualToString:@"✓"]){
                    movieToCreate.viewed = [NSNumber numberWithInt:LMViewedYES];
                }
                else if([[OrderedInfoForNewMovie valueForKey:@"viewed"] isEqualToString:@"?"]){
                    movieToCreate.viewed = [NSNumber numberWithInt:LMViewedUnknown];
                }
                else
                {
                    movieToCreate.viewed = [NSNumber numberWithInt:LMViewedUnknown];
                }
                
                
                
                //NSLog(@"dehors2 %@", [NSThread currentThread]);
                progress = progress + percentsPerMovie;
                dispatch_async(dispatch_get_main_queue(), ^{
                    //NSLog(@" dedans 2%@", [NSThread currentThread]);
                    //NSLog(@"%f", _progressView.progress);
                    _progressView.progress = progress;
                });
                //NSLog(@"now: %f", now-_progressView.progress);
            }
            else
            {
                //echec de l'import
                [_movieManager deleteMovie:movieToCreate];
            }
        }
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _progressView.progress = 1;
        [_movieManager saveContext];
    });
    //DLog(@"Import ok, sauvegarde du contexte demandé");
    

    
    
}











- (void)exportProcedure{
    
    
    //Get all movies
    NSManagedObjectContext *context = [_movieManager managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Movie"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSArray *movies = [context executeFetchRequest:request error:nil];
    
    
    //Format the date to add it to the filename
    NSString *toWrite = @"";
    NSDate *date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'-'HH'h'mm'm'ss's'"];
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:~ NSTimeZoneCalendarUnit fromDate:[NSDate date]];
    date = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
        
    NSString *fileName = [[NSLocalizedString(@"ExportedMovies KEY",@"") stringByAppendingString:[dateFormatter stringFromDate:date ]] stringByAppendingString:@".txt"];
    
    
    //Path where to create the file
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    [toWrite writeToFile:filePath atomically:TRUE encoding:NSUTF8StringEncoding error:NULL];
    NSFileHandle *fileHandler = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
    
    
    
    
    //Writing in the file
    
    DLog(@"fichier écrit vers: %@", filePath);
    float percentDonePerMovie = 1.0/[movies count];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_progressView setDetailsLabelText:[NSString stringWithFormat:@"%d movies", [movies count]]];
    });
    
    NSMutableArray *keys = [[MovieManagerUtils orderedKey] mutableCopy];
    [keys removeObjectAtIndex:0]; //pas d'image
    [keys addObject:@"tmdb_ID"]; //ajout de tmdb_ID
    
    for(Movie *movie in movies){
        toWrite = @"";
        
        //concat all information in one string
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
            toWrite = [toWrite stringByAppendingString:info];
            toWrite = [toWrite stringByAppendingString:@"\t"];
        }
        
        //write it in the file
        toWrite = [toWrite stringByAppendingString:@"\n"];
        [fileHandler seekToEndOfFile];
        [fileHandler writeData:[toWrite dataUsingEncoding:NSUTF8StringEncoding]];
        dispatch_async(dispatch_get_main_queue(), ^{
            _progressView.progress = _progressView.progress + percentDonePerMovie;
        });
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _progressView.progress = 1;
    });
 
    
    [fileHandler closeFile];

    
}


@end
