//
//  EditableCellForMovieTVC.h
//  LMovie
//
//  Created by Jonathan Duss on 15.08.12.
//
//

#import <UIKit/UIKit.h>
#import "MovieEditorGeneralCell.h"
#import "MovieManager.h"


/** Cell containing a SegmentedButton */
@interface CellWithSegmentedButton : UITableViewController <UITextFieldDelegate>
@property (nonatomic, strong) NSMutableDictionary *valueEntered;



-(void)textFieldDidEndEditing:(UITextField *)textField;
- (IBAction)segmentControlChanged:(UISegmentedControl *)sender;
-(void)rateChangeForKey:(NSString *)key newRate:(float)rate;

@end
