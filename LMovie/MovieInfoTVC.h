//
//  MovieIntoTVC.h
//  LMovie
//
//  Created by Jonathan Duss on 15.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieManager.h"
#import "infoFormattedForArray.h"
#import "MovieEditorPictureCell.h"
#import "MovieEditorTVC.h"
#import "NSString+MultipleStringCompare.h"


@interface MovieInfoTVC : UITableViewController <MovieEditorDelegate>
@property (nonatomic, strong) MovieManager *movieManager;
@property (nonatomic, strong) Movie *movie;
- (IBAction)deleteButtonPressed:(UIBarButtonItem *)sender;
@property (strong, nonatomic) UIPopoverController *popover;

-(void)prepareData;
@end
