//
//  DetailTableViewControler.h
//  LMovie
//
//  Created by Jonathan Duss on 20.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplitViewBarItemPresenter.h"

@interface TableViewControler : UITableViewController <SplitViewBarItemPresenter> 
@property (weak, nonatomic) IBOutlet UIButton *boutonTest;

@end
