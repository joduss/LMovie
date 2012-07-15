//
//  MovieEditorDelegate.h
//  LMovie
//
//  Created by Jonathan Duss on 11.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utilities.h"

@protocol MovieEditorDelegate <NSObject>
- (void)actionExecuted:(ActionDone)action;

-(void)showMeAgain:(UIViewController *)vc;
@end
