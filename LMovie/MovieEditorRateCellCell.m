//
//  MovieEditorRateCellCell.m
//  LMovie
//
//  Created by Jonathan Duss on 24.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovieEditorRateCellCell.h"

@interface MovieEditorRateCellCell ()
- (void)initialize;
@end


@implementation MovieEditorRateCellCell
@synthesize rateView = _rateView;
@synthesize movie = _movie;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initialize
{
    _rateView.notSelectedImage = [UIImage imageNamed:@"empty.jpg"];
    _rateView.halfSelectedImage = [UIImage imageNamed:@"middle.jpg"];
    _rateView.fullSelectedImage = [UIImage imageNamed:@"full.jpg"];
    _rateView.rating = [_movie.user_rate floatValue];
    _rateView.editable = NO;
    _rateView.maxRating = 10;
}




-(void)rateView:(RateView *)rateView ratingDidChange:(float)rating
{
    
}

-(void)setDelegate:(id)delegate
{  
    _rateView.delegate = delegate;
}

-(id)delegate
{
    return _rateView.delegate;
}

@end
