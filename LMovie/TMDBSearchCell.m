//
//  TMDBSearchCell.m
//  LMovie
//
//  Created by Jonathan Duss on 24.08.12.
//
//

#import "TMDBSearchCell.h"


@implementation TMDBSearchCell


/** setup the cell with the information for the movie precised with the given movieID */
-(void)setInfosWithTMDBMovieID:(NSString *)movieID{
    [self resetCell];
    
    __block TMDBMovie *movie = [[TMDBMovie alloc] initWithMovieID:movieID];
    
    //BOOL ready = NO;
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [movie loadBasicInfoFromTMDB];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            //DLog(@"image: %@", [UIImage imageWithData:imageData]);
            
            [_posterView setImage:[movie miniPicture]];                        
            _titleAndYearLabel.text = movie.title;
            _yearLabel.text = movie.year;
            _directorLabel.text = movie.directors;
            movie = nil;
            // Add code here to update the UI/send notifications based on the
            // results of the background processing
        });
    });
    
}

-(void)resetCell
{
    _titleAndYearLabel.text = @"Loading...";
    _yearLabel.text = @"";
    _directorLabel.text = @"";
    [_posterView setImage:nil];

}


@end
