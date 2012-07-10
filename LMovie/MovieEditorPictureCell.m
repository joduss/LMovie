//
//  MovieEditorPictureCell.m
//  LMovie
//
//  Created by Jonathan Duss on 10.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovieEditorPictureCell.h"

@implementation MovieEditorPictureCell

@synthesize imageViewHere = _imageViewHere;
@synthesize image = _image;
@synthesize keyAssociated = _keyAssociated;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

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
