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

+(UIImage *)resizeImageToBig:(UIImage *)image;
+(UIImage *)resizeImageToMini:(UIImage *)image;



@end
