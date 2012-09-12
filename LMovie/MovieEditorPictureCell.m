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
@synthesize selectButton = _selectButton;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];

    return self;
}

-(void)awakeFromNib
{
    [self.selectButton setTitle: NSLocalizedString(@"Select Picture KEY", @"") forState:UIControlStateNormal];
    [self.deleteImageButton setTitle:NSLocalizedString(@"Delete picture KEY", @"") forState:UIControlStateNormal];
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellImage:(UIImage *)cellImage
{
    _cellImage = cellImage;
    [_cellImageView setImage:cellImage];
}



@end
