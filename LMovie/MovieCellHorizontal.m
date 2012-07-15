 //
//  MovieCellHorizontal.m
//  LMovie
//
//  Created by Jonathan Duss on 02.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovieCellHorizontal.h"

@implementation MovieCellHorizontal
@synthesize picture = _picture;
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
@synthesize viewedPicture = _viewedPicture;

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
    if(movie.picture == nil){
        NSLog(@"Picture nil");
        NSString *file = [[NSBundle mainBundle] pathForResource:@"emptyartwork_mini" ofType:@"jpg"];
        [_picture setImage:[UIImage imageWithContentsOfFile:file]]; 
    }
    else {
        NSLog(@"Picture non nil");
        [_picture setImage:[UIImage imageWithData:movie.picture]];
    }
    _title.text = movie.title;
    _year.text = [movie.year stringValue];
    _duration.text = [movie.duration stringValue];
    
    //USER RATE
    //TMDBRATE
    
    _director.text = movie.director;
    _actor.text = movie.actors;
    _viewed.text = [movie.viewed stringValue];
    
    //VIEWED PICTURe
    
    
    
    
}

@end
