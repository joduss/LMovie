//
//  DownloadMoviePoster.h
//  LMovieB
//
//  Created by Jonathan Duss on 17.02.13.
//
//

#import <Foundation/Foundation.h>
#import "Movie+Info.h"
#import "MovieManager.h"
#import "MBProgressHUDOnTop.h"


#define MAX_TRY 3
#define MAX_TRY_THREAD 10
#define MAX_DOWNLOADS 5


@interface DownloadMoviePoster : NSObject

+(void)downloadPosters;

@end
