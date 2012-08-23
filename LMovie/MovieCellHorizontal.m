 //
//  MovieCellHorizontal.m
//  LMovie
//
//  Created by Jonathan Duss on 02.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovieCellHorizontal.h"

@implementation MovieCellHorizontal
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


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


-(void)configureCellWithMovie:(Movie *)movie{
#warning - uncomplete definition
    
    self.userRate.notSelectedImage = [UIImage imageNamed:@"empty.jpg"];
    self.userRate.halfSelectedImage = [UIImage imageNamed:@"middle.jpg"];
    self.userRate.fullSelectedImage = [UIImage imageNamed:@"full.jpg"];
    self.userRate.rating = [movie.user_rate floatValue];
    self.userRate.editable = NO;
    self.userRate.maxRating = 10;
    self.userRate.delegate = self;
    
    self.tmdbRate.notSelectedImage = [UIImage imageNamed:@"empty.jpg"];
    self.tmdbRate.halfSelectedImage = [UIImage imageNamed:@"middle.jpg"];
    self.tmdbRate.fullSelectedImage = [UIImage imageNamed:@"full.jpg"];
    self.tmdbRate.rating = [movie.tmdb_rate floatValue];
    self.tmdbRate.editable = NO;
    self.tmdbRate.maxRating = 10;
    self.tmdbRate.delegate = self;
    
    
    
    
    
    
    
    
    
    
    
    
    if(movie.mini_picture == nil){
        //DLog(@"Picture nil");
        [_picture setImage:nil];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *file = [[NSBundle mainBundle] pathForResource:@"emptyartwork_mini" ofType:@"jpg"];
            UIImage * img = [UIImage imageWithContentsOfFile:file];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [_picture setImage:img];
            });
        });
    }
    else {
        //DLog(@"Picture non nil");
        [_picture setImage:nil];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage * img = [UIImage imageWithData:movie.mini_picture];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [_picture setImage:img];
            });
        });
    }
    _title.text = movie.title;
    _year.text = [movie.year stringValue];
    int hour = [movie.duration intValue] / 60;
    int minute = [movie.duration intValue] - hour * 60;
    _duration.text = [NSString stringWithFormat:@"%d:%02d", hour, minute];
    
    //USER RATE
    //TMDBRATE
    
    if(movie.director == nil){
        _director.text = @"Director: ";
    }
    else {
        _director.text = [@"Director: " stringByAppendingString:movie.director];

    }
    if(movie.actors == nil){
        _actor.text = @"Actor";
    }
    else {
        _actor.text = [@"Actor: " stringByAppendingString:movie.actors];
    }

    _labelAfterTMDBRate.text = [movie.tmdb_rate stringValue];
    _labelAfterUserRate.text = [movie.user_rate stringValue];
    _viewed.text = [movie.viewed stringValue];
    
    //VIEWED PICTURe
    
    
    
    
}



- (void)rateView:(RateView *)rateView ratingDidChange:(float)rating {
    //self.statusLabel.text = [NSString stringWithFormat:@"Rating: %f", rating];
}

@end
