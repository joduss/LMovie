//
//  utilities2.m
//  LMovie
//
//  Created by Jonathan Duss on 12.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "utilities.h"


#define MAX_SIZE_BIG 850
#define MAX_SIZE_MINI 150



@implementation utilities
+(UIImage *)resizeImageToBig:(UIImage *)image{
    if(image.size.width > MAX_SIZE_BIG || image.size.width > MAX_SIZE_BIG){
        double ratio = image.size.height / image.size.width;
        float newWidth;
        float newHeith;
        
        if(image.size.width > image.size.height){
            newWidth = MAX_SIZE_BIG;
            newHeith = newWidth * ratio;
        }
        else {
            newHeith = MAX_SIZE_BIG;
            newWidth = newHeith / ratio;
        }
        
        //resize l'image:
        CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newWidth, newHeith));
        CGImageRef imageRef = image.CGImage;
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(newWidth, newHeith), NO, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        // Set the quality level to use when rescaling
        CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
        CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newHeith);
        
        CGContextConcatCTM(context, flipVertical);  
        // Draw into the context; this scales the image
        CGContextDrawImage(context, newRect, imageRef);
        
        // Get the resized image from the context and a UIImage
        CGImageRef newImageRef = CGBitmapContextCreateImage(context);
        UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
        
        CGImageRelease(newImageRef);
        UIGraphicsEndImageContext();    

        return newImage;
    }
    else {
        return image;
    }

}


+(UIImage *)resizeImageToMini:(UIImage *)image{
    if(image.size.width > MAX_SIZE_MINI || image.size.width > MAX_SIZE_MINI){
        double ratio = image.size.height / image.size.width;
        float newWidth;
        float newHeith;
        
        if(image.size.width > image.size.height){
            newWidth = MAX_SIZE_MINI;
            newHeith = newWidth * ratio;
        }
        else {
            newHeith = MAX_SIZE_MINI;
            newWidth = newHeith / ratio;
        }
        
        //resize l'image:
        CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newWidth, newHeith));
        CGImageRef imageRef = image.CGImage;
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(newWidth, newHeith), NO, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        // Set the quality level to use when rescaling
        CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
        CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newHeith);
        
        CGContextConcatCTM(context, flipVertical);  
        // Draw into the context; this scales the image
        CGContextDrawImage(context, newRect, imageRef);
        
        // Get the resized image from the context and a UIImage
        CGImageRef newImageRef = CGBitmapContextCreateImage(context);
        UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
        
        CGImageRelease(newImageRef);
        UIGraphicsEndImageContext();    
        
        return newImage;
    }
    else {
        return image;
    }
    
}

@end
