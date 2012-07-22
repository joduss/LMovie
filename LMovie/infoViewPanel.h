//
//  infoViewPanel.h
//  LMovie
//
//  Created by Jonathan Duss on 08.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyMovie.h"
#import "MovieManager.h"
#import "MovieEditorGeneralCell.h"

@interface infoViewPanel : UIView <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic)  IBOutlet UITableView *tableView;
@property (nonatomic, strong) Movie *movieToEdit;
@property (nonatomic, strong) MovieManager *movieManager;
@end
