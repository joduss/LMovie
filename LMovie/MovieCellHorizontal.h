//
//  MovieCellHorizontal.h
//  LMovie
//
//  Created by Jonathan Duss on 02.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCellHorizontal : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *year;
@property (strong, nonatomic) IBOutlet UILabel *director;
@property (strong, nonatomic) IBOutlet UILabel *actor;
@property (strong, nonatomic) IBOutlet UILabel *viewed;
@property (strong, nonatomic) IBOutlet UILabel *rate;

@end
