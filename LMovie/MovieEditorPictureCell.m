//
//  MovieEditorPictureCell.m
//  LMovie
//
//  Created by Jonathan Duss on 10.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovieEditorPictureCell.h"

@implementation MovieEditorPictureCell

@synthesize cellImageView = _cellImageView;
@synthesize cellImage = _cellImage;
@synthesize keyAssociated = _keyAssociated;




- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




-(IBAction)selectImage:(UIButton *)sender
{
    NSLog(@"selectImage...");
}

@end
