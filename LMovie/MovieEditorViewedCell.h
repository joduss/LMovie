//
//  MovieEditorViewedCell.h
//  LMovie
//
//  Created by Jonathan Duss on 24.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieEditorViewedCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel* infoLabel;
@property (nonatomic, weak) IBOutlet UISegmentedControl *choice;


@end
