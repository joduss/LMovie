//
//  MovieEditorTVC.h
//  LMovie
//
//  Created by Jonathan Duss on 10.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieManager.h"

@interface MovieEditorTVC : UITableViewController
@property Movie *movieToEdit;
@property MovieManager *movieManager;
@end
