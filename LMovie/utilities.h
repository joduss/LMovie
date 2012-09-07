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


typedef enum LMResolution {
    LMResolutionUnknown = 0,
    LMResolutionAVI = 1,
    LMResolutionDVD = 2,
    LMResolution720 = 3,
    LMResolution1080 = 4,
    LMResolution3D = 5
} LMResolution;


@interface utilities : NSObject

+(UIImage *)resizeImageToBig:(UIImage *)image;
+(UIImage *)resizeImageToMini:(UIImage *)image;


+(NSString *)stringFromArray:(NSArray *)array;



@end
