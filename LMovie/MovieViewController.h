//
//  MovieViewController.h
//  LMovie
//
//  Created by Jonathan Duss on 02.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainCellHorizontal.h"
#import "Utilities.h"
#import "MovieEditorTVC.h"
#import "MovieInfoTVC.h"
#import "SeguePopoverMovieInfoTVC.h"
#import "SearchTVC.h"
#import "TMDBSearchTVC.h"


@interface MovieViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MovieEditorDelegate, NSFetchedResultsControllerDelegate, SearchTVCDelegate, UIActionSheetDelegate, MovieInfoProtocol>

@property IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *bouton;


- (IBAction)addAMovieButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)modif:(id)sender;
- (IBAction)searchButtonPressed:(UIBarButtonItem *)sender;

- (void)executeSearchWithInfo:(NSDictionary *)info;


@end
