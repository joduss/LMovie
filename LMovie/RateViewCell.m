//
//  RateViewCell.m
//  LMovie
//
//  Created by Jonathan Duss on 06.08.12.
//
//

#import "RateViewCell.h"

@implementation RateViewCell

@synthesize rateView = _rateView;
@synthesize infoLabel = _infoLabel;
@synthesize rate = _rate;
@synthesize key = _key;
@synthesize delegate = _delegate;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configureCellWithRate:(float)rate{
    self.rateView.notSelectedImage = [UIImage imageNamed:@"empty.png"];
    self.rateView.halfSelectedImage = [UIImage imageNamed:@"middle.png"];
    self.rateView.fullSelectedImage = [UIImage imageNamed:@"full.png"];
    self.rateView.rating = rate;
    self.rateView.editable = YES;
    self.rateView.maxRating = 10;
    self.rateView.delegate = self;
}

-(void)setRate:(float)rate
{
    self.rateView.rating = rate;
}


- (void)rateView:(RateView *)rateView ratingDidChange:(float)rating{
    if(self.delegate){
        DLog(@"rateViwe ratingDidChange: %f", rating);
        [self.delegate rateChangeForKey:_key newRate:rating];
    }
}



@end
