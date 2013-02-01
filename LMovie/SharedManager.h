//
//  SharedManager.h
//  LMovieB
//
//  Created by Jonathan Duss on 01.02.13.
//
//

#import <Foundation/Foundation.h>
#import "Movie+Info.h"

@interface SharedManager : NSObject

@property (readonly, strong) UIImage *emptyStar;
@property (readonly, strong) UIImage *halfStar;
@property (readonly, strong) UIImage *fullStar;
@property (readonly, strong) UIImage *viewedIconYES;
@property (readonly, strong) UIImage *viewedIconNO;
@property (readonly, strong) UIImage *viewedIconMAYBE;



+ (id)getInstance;
-(UIImage *)viewedIcon:(ViewedState)viewedState;




@end
