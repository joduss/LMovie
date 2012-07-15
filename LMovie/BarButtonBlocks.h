//
//  BarButtonBlocks.h
//  LMovie
//
//  Created by Jonathan Duss on 15.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^actionBlock)();


@interface BarButtonBlocks : UIBarButtonItem
-(id)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style action:(actionBlock)action;


@end
