//
//  infoViewPanel.m
//  LMovie
//
//  Created by Jonathan Duss on 08.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "infoViewPanel.h"

@implementation infoViewPanel

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
       /* UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"infoView" owner:self options:nil] objectAtIndex:0];
        [self addSubview: view];*/
    }
    NSLog(@"infoViewPanel loaded");
    return self;
}

- (void)awakeFromNib
{
    NSLog(@"awake form nib");
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
