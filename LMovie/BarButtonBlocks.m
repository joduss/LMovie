//
//  BarButtonBlocks.m
//  LMovie
//
//  Created by Jonathan Duss on 15.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BarButtonBlocks.h"

@interface BarButtonBlocks ()
@property (nonatomic, copy) actionBlock actionToDo;


@end

@implementation BarButtonBlocks
@synthesize actionToDo = _actionToDo;

-(id)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style action:(actionBlock)action
{
    self = [super initWithTitle:title style:style target:self action:@selector(doAction)];
    _actionToDo = action;
    return self;
}

-(void)doAction
{
    _actionToDo();
}


@end
