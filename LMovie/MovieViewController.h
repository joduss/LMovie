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
#import "PanelSegue.h"
#import "MovieInfoTVC.h"
#import "SeguePopoverMovieInfoTVC.h"

@interface MovieViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MovieEditorDelegate, NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *connard;
- (IBAction)addAMovieButtonPressed:(UIBarButtonItem *)sender;
@property IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *bouton;

@end
