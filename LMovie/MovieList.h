//
//  MovieList.h
//  LMovie
//
//  Created by Jonathan Duss on 02.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieManager.h"

@interface MovieList : UITableViewController <NSFetchedResultsControllerDelegate>
- (IBAction)coucou:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *buttonT;


@end
