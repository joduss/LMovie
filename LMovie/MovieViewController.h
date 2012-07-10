//
//  MovieViewController.h
//  LMovie
//
//  Created by Jonathan Duss on 02.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieCellHorizontal.h"
#import "infoViewPanel.h"

@interface MovieViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *connard;
- (IBAction)fuck:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *detailPanel;

@end
