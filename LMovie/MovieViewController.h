//
//  MovieViewController.h
//  LMovie
//
//  Created by Jonathan Duss on 02.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieCellHorizontal.h"
#import "infoViewPanel.h"
#import "Utilities.h"
#import "MovieEditorTVC.h"

@interface MovieViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MovieEditorDelegate>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *connard;
- (IBAction)fuck:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *detailPanel;
- (IBAction)addAMovieButtonPressed:(UIBarButtonItem *)sender;

@end
