//
//  ImportExport.m
//  LMovieB
//
//  Created by Jonathan Duss on 16.02.13.
//
//

#import "ImportExport.h"


@interface ImportExport ()
@property MBProgressHUD *progressView;
@property MovieManager *movieManager;
@property UIView *blackBackGroud;
@property UIViewController *topVC;
@property UIWindow *window;
@end


@implementation ImportExport




-(id)init{
    self = [super init];
    _movieManager = [MovieManager instance];
    _topVC = [[UIApplication sharedApplication].keyWindow topMostController];
    _window = [UIApplication sharedApplication].keyWindow;
    return self;
}

-(void)showProgressAnimation{
    
    
    
    
    CGRect winFrame = _topVC.view.bounds;
    
    //DLog(@"Background: %f, %f", winFrame.size.height, winFrame.size.width);
    
    _blackBackGroud = [[UIView alloc] initWithFrame:winFrame];
    _blackBackGroud.alpha = 0.0;
    [_blackBackGroud setHidden:NO];
    [_topVC.view addSubview:_blackBackGroud];
    [_topVC.view bringSubviewToFront:_blackBackGroud];
    [_blackBackGroud setHidden:NO];
    [_blackBackGroud setBackgroundColor:[UIColor blackColor]];
    
    [UIView animateWithDuration:0.5 animations:^{
        [_blackBackGroud setAlpha:0.5];
    }];
    
    
    
    _progressView = [[MBProgressHUD alloc]initWithWindow:[UIApplication sharedApplication].keyWindow];
    [_topVC.view addSubview:_progressView];
    
    
    [_progressView setMode:MBProgressHUDModeDeterminate];
    [_progressView show:YES];
    [_progressView setMinShowTime:1];
}

-(void)hideProgressAnimation{
    [_progressView hide:YES];
        
    [UIView animateWithDuration:0.5 animations:^{
        [_blackBackGroud setAlpha:0];
    } completion:^(BOOL finished){
        [_blackBackGroud removeFromSuperview];
    }];
    
    
}



-(void)import{
    [self showProgressAnimation];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Show the HUD in the main tread
        
        // Do a taks in the background
        [self import2];
        
        // Hide the HUD in the main tread
        dispatch_async(dispatch_get_main_queue(), ^{
            //[MBProgressHUD hideHUDForView:self.view animated:YES];
            [self hideProgressAnimation];
        });
    });
}


- (void)import2
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
        DLog(@"movie : |%@|", movie);
        if(![movie isEqualToString:@"\n"] && ![movie isEqualToString:@""]){
            NSMutableArray *movieInfo = [[movie componentsSeparatedByString:@"\t"] mutableCopy];
            [movieInfo removeLastObject];
            int i = 0;
            NSMutableDictionary *infoForNewMovie = [[NSMutableDictionary alloc] init];
            
            
            //on supprime la clé "big_picture" car pas besoin
            NSMutableArray *keys = [[MovieManagerUtils orderedKey] mutableCopy];
            [keys removeObjectAtIndex:0];
            [keys addObject:@"tmdb_ID"];
            if([keys count] != [movieInfo count]){
                [keys removeLastObject];
            }
            
            //recontrole le nombre de valeur en fonction du nombre de clé. Si à nouveau pas =: on abandonne.
            if([keys count] == [movieInfo count]){
                
                DLog(@"ARRRAY: %@",[movieInfo description]);
                
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
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _progressView.progress = 1;
    });
    //DLog(@"Import ok, sauvegarde du contexte demandé");
    
    [_movieManager saveContext];
    
    
    //[self dismissModalViewControllerAnimated:YES];
}


@end
