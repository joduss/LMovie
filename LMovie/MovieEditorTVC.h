//
//  MovieEditorTVC.h
//  LMovie
//
//  Created by Jonathan Duss on 10.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieManager.h"
#import "MovieEditorPictureCell.h"
#import "MovieEditorGeneralCell.h"
#import "Utilities.h"
#import "MovieEditorDelegate.h"
#import "RateViewCell.h"
#import "ResolutionPickerVC.h"
#import <AssetsLibrary/AssetsLibrary.h>


/** This class presents a table view to edit the movie */
@interface MovieEditorTVC : UITableViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, RateViewCellDelegate, ResolutionPickerVC, UIPopoverControllerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property Movie *movieToEdit;
@property MovieManager *movieManager;
@property (nonatomic, weak) id <MovieEditorDelegate> delegate;
- (IBAction)resetButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)pickImage:(id)sender;
@property (nonatomic, weak) UIPopoverController *popover;
- (IBAction)segmentControlChanged:(UISegmentedControl *)sender;
@property (nonatomic, strong) NSMutableDictionary *movieInformation;
@property (nonatomic) BOOL addedFromTMDB;
-(void)deleteImage;

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController;

-(BOOL)textFieldShouldReturn:(UITextField *)textField;



@end
