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
#import "SearchTVC.h"


@interface MovieViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MovieEditorDelegate, NSFetchedResultsControllerDelegate, SearchTVCDelegate>
- (IBAction)addAMovieButtonPressed:(UIBarButtonItem *)sender;
@property IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *bouton;
@property (strong, nonatomic) IBOutlet MovieEditorTVC *movieEditor;
-(void)executeSearchWithInfo:(NSDictionary *)info;


@end
