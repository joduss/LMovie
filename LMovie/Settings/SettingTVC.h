//
//  SettingTVC.h
//  LMovie
//
//  Created by Jonathan Duss on 09.08.12.
//
//

#import <UIKit/UIKit.h>
#import "MovieManager.h"
#import "utilities.h"

#define MAX_TRY 3

@interface SettingTVC : UITableViewController 
@property (weak, nonatomic) IBOutlet UITableViewCell *exportCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *importCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *downloadMoviePosterCell;
@property (weak, nonatomic) MovieManager *movieManager;
@property (weak, nonatomic) IBOutlet UISegmentedControl *appLanguageChooser;

- (void)export;
- (void)import;

-(void)downloadMoviePoster;

-(IBAction)okButtonPressed:(id)sender;

@end
