//
//  MovieEditorGeneralCell.h
//  LMovie
//
//  Created by Jonathan Duss on 10.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieEditorGeneralCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UITextField *textField;
@property (nonatomic, strong) NSString *associatedKey;
@property (nonatomic, strong) IBOutlet UILabel *infoLabel;
@end





