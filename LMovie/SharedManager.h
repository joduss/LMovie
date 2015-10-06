//
//  SharedManager.h
//  LMovieB
//
//  Created by Jonathan Duss on 01.02.13.
//
//

#import <Foundation/Foundation.h>
#import "Movie+Info.h"


/**Provide a way to load star images in a fast way. Keeps them in memory has they are access very often*/
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
