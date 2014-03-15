//
//  LMImageManager.m
//  LMovieB
//
//  Created by Jonathan Duss on 27.04.13.
//
//

#import "LMImageManager.h"

@implementation LMImageManager


+(void)saveImage:(UIImage *)image withName:(NSString *)name{
    if([self dirExist]){
        
        NSString *path = [[self imageDirectory] stringByAppendingPathComponent:name];
        
        if([self imageExistsWithName:name]){
            [self deleteImageWithName:name];
        }
        
        [UIImagePNGRepresentation(image) writeToFile:path atomically:YES];
    }
    else
    {
        //handle error
    }
    
}


+(UIImage *)loadImageWithName:(NSString *)name{
    NSString *path = [[self imageDirectory] stringByAppendingPathComponent:name];
    UIImage *img = [UIImage imageWithContentsOfFile:path];
    
    return img;
}


+(BOOL)imageExistsWithName:(NSString *)name {
    NSString *path = [[self imageDirectory] stringByAppendingPathComponent:name];
    NSFileManager *mngr = [NSFileManager defaultManager];
    return [mngr fileExistsAtPath:path isDirectory:NO];
}


+(void)deleteImageWithName:(NSString *)name{
    if([self imageExistsWithName:name] == NO){
        NSString *path = [[self imageDirectory] stringByAppendingPathComponent:name];
        UIImage *img = [UIImage imageWithContentsOfFile:path];
        NSFileManager *mngr = [NSFileManager defaultManager];
        
        NSError *error;
        [mngr removeItemAtPath:path error:&error];
    }
}


+(BOOL)dirExist{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error;
        
    NSString *imageDir = [self imageDirectory];

    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:imageDir]){
        NSString *imageDir = [self imageDirectory];
        [fm createDirectoryAtPath:imageDir
      withIntermediateDirectories:NO
                       attributes:nil
                            error:&error];
        if(  error != nil)
        {
            return NO;
            NSLog(@"[%@] ERROR: attempting to write create MyFolder directory", [self class]);
            NSAssert( FALSE, @"Failed to create directory maybe out of disk space?");
        }
    }
    return YES;
}



+(NSString *)imageDirectory{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSURL *documentDir = [[fm URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] objectAtIndex:0 ];
    return [[documentDir URLByAppendingPathComponent:@"covers" isDirectory:YES] absoluteString];
}
@end
