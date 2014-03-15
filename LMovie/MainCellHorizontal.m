 //
//  MovieCellHorizontal.m
//  LMovie
//
//  Created by Jonathan Duss on 02.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainCellHorizontal.h"

@implementation MainCellHorizontal
/*@synthesize picture = _picture;
@synthesize title = _title;
@synthesize year = _year;
@synthesize duration = _duration;
@synthesize labelBeforeUserRate = _labelBeforeUserRate;
@synthesize labelBeforetmdbRate = _labelBeforetmdbRate;
@synthesize userRate = _userRate;
@synthesize tmdbRate = _tmdbRate;
@synthesize director = _director;
@synthesize actor =_actor;
@synthesize viewed = _viewed;
@synthesize viewedPicture = _viewedPicture;*/



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


-(void)configureCellWithMovie:(Movie *)movie{
          
            self.userRate.notSelectedImage = [[SharedManager getInstance] emptyStar];
            self.userRate.halfSelectedImage = [[SharedManager getInstance] halfStar];
            self.userRate.fullSelectedImage = [[SharedManager getInstance] fullStar];
            self.userRate.rating = [movie.user_rate floatValue];
            self.userRate.editable = NO;
            self.userRate.maxRating = 10;
            self.userRate.delegate = self;
            
            self.tmdbRate.notSelectedImage = [[SharedManager getInstance] emptyStar];
            self.tmdbRate.halfSelectedImage = [[SharedManager getInstance] halfStar];
            self.tmdbRate.fullSelectedImage = [[SharedManager getInstance] fullStar];
            self.tmdbRate.rating = [movie.tmdb_rate floatValue];
            self.tmdbRate.editable = NO;
            self.tmdbRate.maxRating = 10;
            self.tmdbRate.delegate = self;

    
    [_picture setImage:nil];
            //DLog(@"Picture non nil");
    
    
    
    [_picture setImage:movie.mini_cover];

        
    
    _title.text = movie.title;
    _year.text = [movie.year stringValue];
    int hour = [movie.duration intValue] / 60;
    int minute = [movie.duration intValue] - hour * 60;
    _duration.text = [NSString stringWithFormat:@"%d:%02d", hour, minute];
    

    
    if(movie.director == nil){
        _director.text = NSLocalizedString(@"Director : KEY",@"");
    }
    else {
        _director.text = [NSLocalizedString(@"Director : KEY",@"") stringByAppendingString:movie.director];

    }
    if(movie.actors == nil){
        _actor.text = NSLocalizedString(@"Actors : KEY",@"");
    }
    else {
        NSString *actorsString = movie.actors;
        NSArray *actorsArray = [actorsString componentsSeparatedByString:@", "];
        NSString *actorsToShow;
        if([actorsArray count] >= 2){
            actorsToShow = [[actorsArray objectAtIndex:0] stringByAppendingFormat:@", %@",[actorsArray objectAtIndex:1]]; //On affiche 2 acteurs
        }
        else{
            actorsToShow = [actorsArray objectAtIndex:0];
        }
        
        _actor.text = [NSLocalizedString(@"Actors : KEY",@"") stringByAppendingString:actorsToShow];
    }
    
    
    //SET OF "VIEWED ICON"
    __block UIImage *viewedIcon;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        switch ([movie.viewed intValue]) {
            case 0:
                viewedIcon = [[SharedManager getInstance] viewedIconNO];
                break;
            case 1:
                viewedIcon = [[SharedManager getInstance] viewedIconYES];
                break;
            default:
                viewedIcon = [[SharedManager getInstance] viewedIconMAYBE];
                break;
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            [_viewedPicture setImage:viewedIcon];

        });
    });
    
    viewedIcon = nil;
    

    
    //USER RATE
    //TMDBRATE
    
    //SET OF rate in String next to the star notation
    _labelAfterTMDBRate.text = [movie.tmdb_rate stringValue];
    _labelAfterUserRate.text = [movie.user_rate stringValue];
    
    
    
    
    
}



- (void)rateView:(RateView *)rateView ratingDidChange:(float)rating {
    //self.statusLabel.text = [NSString stringWithFormat:@"Rating: %f", rating];
}

@end
