//
//  MovieCellHorizontal.h
//  LMovie
//
//  Created by Jonathan Duss on 02.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCellHorizontal : UITableViewCell
@property IBOutlet UIImageView *picture;
@property IBOutlet UILabel *title;
@property IBOutlet UILabel *year;
@property IBOutlet UILabel *duration;
@property IBOutlet UILabel *labelBeforeUserRate;
@property IBOutlet UILabel *labelBeforetmdbRate;
@property IBOutlet UIImageView *userRate;
@property IBOutlet UIImageView *tmdbRate;
@property IBOutlet UILabel *director;
@property IBOutlet UILabel *actor;
@property IBOutlet UILabel *viewed;
@property IBOutlet UIImageView *viewedPicture;


@end
