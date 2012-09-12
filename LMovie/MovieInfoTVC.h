//
//  MovieIntoTVC.h
//  LMovie
//
//  Created by Jonathan Duss on 15.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieManager.h"
#import "MovieEditorPictureCell.h"
#import "MovieEditorTVC.h"
#import "NSString+MultipleStringCompare.h"





@interface MovieInfoTVC : UITableViewController <MovieEditorDelegate, UIPopoverControllerDelegate>
@property (nonatomic, strong) MovieManager *movieManager;
@property (nonatomic, strong) Movie *movie;
@property (strong, nonatomic) UIPopoverController *popover;

- (IBAction)deleteButtonPressed:(UIBarButtonItem *)sender;

-(void)prepareData;


@end


