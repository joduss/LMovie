//
//  MovieCellHorizontal.m
//  LMovie
//
//  Created by Jonathan Duss on 02.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovieCellHorizontal.h"

@implementation MovieCellHorizontal
@synthesize title = _title;
@synthesize year = _year;
@synthesize director = _director;
@synthesize actor = _actor;
@synthesize viewed = _viewed;
@synthesize rate = _rate;

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

    // Configure the view for the selected state
}

@end
