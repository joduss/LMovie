//
//  utilities2.h
//  LMovie
//
//  Created by Jonathan Duss on 12.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum ActionDoneIn {
    ActionReset = 0,
    ActionSaveNew = 1,
    ActionSaveModification = 2
} ActionDone;





@interface utilities : NSObject

//Resize a huge image to a smaller bug big image
+(UIImage *)resizeImageToBig:(UIImage *)image;
///Resized a huge image to a mini image
+(UIImage *)resizeImageToMini:(UIImage *)image;

/// Represent an array in string betten than [array description]
+(NSString *)stringFromArray:(NSArray *)array;


+(CGRect)getScreenBoundsForOrientation:(UIInterfaceOrientation)orientation;
@end
