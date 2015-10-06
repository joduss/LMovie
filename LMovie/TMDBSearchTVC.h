//
//  TMDBSearchTVC.h
//  LMovie
//
//  Created by Jonathan Duss on 24.08.12.
//
//

#import <UIKit/UIKit.h>
#import "TMDBSearchCell.h"
#import "MBProgressHUD.h"
#import "MovieEditorTVC.h"


/** TV displaying the movies associated with the user query */

@interface TMDBSearchTVC : UITableViewController <UISearchBarDelegate, UIPopoverControllerDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) UIPopoverController *popover;
@property (strong, nonatomic) MovieManager *movieManager;
- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender;

@end
