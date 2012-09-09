//
//  MovieCellHorizontal.h
//  LMovie
//
//  Created by Jonathan Duss on 02.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"
#import "RateView.h"

@interface MainCellHorizontal : UITableViewCell <RateViewDelegate>
@property IBOutlet UIImageView *picture;
@property IBOutlet UILabel *title;
@property IBOutlet UILabel *year;
@property IBOutlet UILabel *duration;
@property IBOutlet UILabel *labelBeforeUserRate;
@property IBOutlet UILabel *labelBeforetmdbRate;
@property IBOutlet RateView *userRate;
@property IBOutlet RateView *tmdbRate;
@property IBOutlet UILabel *director;
@property IBOutlet UILabel *actor;
@property IBOutlet UIImageView *viewedPicture;
@property IBOutlet UILabel *labelAfterUserRate;
@property IBOutlet UILabel *labelAfterTMDBRate;

-(void)configureCellWithMovie:(Movie *)movie;


@end
