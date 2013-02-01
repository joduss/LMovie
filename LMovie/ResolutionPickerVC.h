//
//  ResolutionPickerVC.h
//  LMovie
//
//  Created by Jonathan Duss on 04.09.12.
//
//

#import <UIKit/UIKit.h>
#import "utilities.h"
#import "MovieManager.h"

@protocol ResolutionPickerVC <NSObject>

-(void)selectedResolution:(LMResolution)resolution;

@end



@interface ResolutionPickerVC : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UIPopoverControllerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (strong, nonatomic) id<ResolutionPickerVC> delegate;
@property (nonatomic, strong) UIPopoverController *popover;
- (IBAction)saveResolutionButtonPressed:(UIBarButtonItem *)sender;
@property (nonatomic) BOOL forSearch;
@end








