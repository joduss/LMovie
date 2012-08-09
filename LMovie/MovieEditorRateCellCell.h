//
//  MovieEditorRateCellCell.h
//  LMovie
//
//  Created by Jonathan Duss on 24.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateView.h"
#import "Movie.h"

@interface MovieEditorRateCellCell : UITableViewCell <RateViewDelegate>
@property (strong, nonatomic) IBOutlet RateView *rateView;
@property (strong, nonatomic) Movie *movie;
@property (nonatomic, weak) id delegate;
@end
