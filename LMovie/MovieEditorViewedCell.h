//
//  MovieEditorViewedCell.h
//  LMovie
//
//  Created by Jonathan Duss on 24.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieEditorViewedCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel* infoLabel;
@property (nonatomic, strong) IBOutlet UISegmentedControl *choice;

@end
