//
//  MovieEditorPictureCell.h
//  LMovie
//
//  Created by Jonathan Duss on 10.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieEditorPictureCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *cellImageView;
@property (nonatomic, strong) UIImage *cellImage;
@property (nonatomic, strong) NSString *keyAssociated;
@property (nonatomic, weak) IBOutlet UIButton *selectButton;
@property (nonatomic, weak) IBOutlet UIButton *deleteImageButton;

@end
