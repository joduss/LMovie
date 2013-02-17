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
#import "ImportExport.h"
#import "DownloadMoviePoster.h"




/**
 Manage the SettingTableViewController and allow the user to set his settings
 */
@interface SettingTVC : UITableViewController  <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableViewCell *appLanguageCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *exportCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *importCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *downloadMoviePosterCell;
@property (weak, nonatomic) MovieManager *movieManager;
@property (weak, nonatomic) IBOutlet UISegmentedControl *appLanguageChooser;

/**
 Export all movie to a .txt
 */


-(void)downloadMoviePoster;

-(IBAction)okButtonPressed:(id)sender;

-(void)stopPictureLoading:(UIGestureRecognizer *)gesture;

@end
