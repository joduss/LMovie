//
//  SettingTVC.h
//  LMovie
//
//  Created by Jonathan Duss on 09.08.12.
//
//

#import <UIKit/UIKit.h>
#import "MovieManager.h"

@interface SettingTVC : UITableViewController
@property (weak, nonatomic) IBOutlet UITableViewCell *exportCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *importCell;
@property (weak, nonatomic) MovieManager *movieManager;

- (void)export;
- (void)import;

-(IBAction)okButtonPressed:(id)sender;

@end
