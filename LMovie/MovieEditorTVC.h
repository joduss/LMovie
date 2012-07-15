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

@interface MovieEditorTVC : UITableViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property Movie *movieToEdit;
@property MovieManager *movieManager;
@property (nonatomic, weak) id <MovieEditorDelegate> delegate;
- (IBAction)resetButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)pickImage:(id)sender;
@property (nonatomic, weak) UIPopoverController *popover;


@end
