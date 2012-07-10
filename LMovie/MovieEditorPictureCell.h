//
//  MovieEditorPictureCell.h
//  LMovie
//
//  Created by Jonathan Duss on 10.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieEditorPictureCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *imageViewHere;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *keyAssociated;
-(IBAction)selectImage:(UIButton*)sender;
@end
