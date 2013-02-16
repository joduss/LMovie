//
//  MovieManagerUtils.h
//  LMovieB
//
//  Created by Jonathan Duss on 03.02.13.
//
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"



typedef enum LMResolution {
    LMResolutionUnknown = 0,
    LMResolutionAVI = 1,
    LMResolutionDVD = 2,
    LMResolution720 = 3,
    LMResolution1080 = 4,
    LMResolution3D = 5,
    LMResolutionAll = 6
} LMResolution;


typedef enum LMViewed {
    LMViewedNO = 0,
    LMViewedYES = 1,
    LMViewedUnknown = 2
} LMViewed;


@interface MovieManagerUtils : NSObject

+ (NSArray *)allKey;
+(NSArray *)keyOrderedBySection;



+(NSArray *)keyOrderedBySection;


+(NSString *)keyAtIndexPath:(NSIndexPath *)path;
/**
 Return the section in which a key should be in the MovieInfoTVC
 @param key the key we want to know the section
 @return the section
 */
+(int)sectionForKey:(NSString *)key;
+(NSString *)labelForKey:(NSString *)key;

/**
 Return the key in the order it should be displayed in the TableView showing all info about a movie
 @return An array with the key in the correct order
 */
+(NSArray *)orderedKey;

/**
 Return the associated placeholder
 @param key the key for which we want the placeholder
 @return the placeholder value
 */
+(NSString *)placeholderForKey:(NSString *)key;

+(NSString *)resolutionToStringForResolution:(LMResolution)resolution;





+(NSString *)saveImageInTemporaryDirectory:(UIImage *)image;
+(NSString *)saveImage:(UIImage *)image;
+(UIImage *)loadImageAtPath:(NSString *)path;
+(NSString *)imageDirectory;


+(NSData *)defaultBigCoverData;
+(NSData *)defaultMiniCoverData;
+(NSString *)defaultBigPicturePath;
+(NSString *)defaultMiniPicturePath;


@end
