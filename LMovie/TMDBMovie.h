//
//  TMDBMovie.h
//  LMovie
//
//  Created by Jonathan Duss on 25.08.12.
//
//

#import <Foundation/Foundation.h>
#import "NSMutableDictionary+LMMutableDictionary.h"
#import "utilities.h"


/** Class that represents a movie (information) downloaded from TMDB.
 It is init with a movieID that got when the user look for a movie coming from TMDB and 
 then select that movie.
 Before doing anything, first call loadBasicInfoFromTMDB just before getting some properties
 */
@interface TMDBMovie : NSObject

-(id)initWithMovieID:(NSString *)movieID;

@property (nonatomic, strong) NSString *movieID;
@property (nonatomic, strong) NSDictionary *infosGeneral;
@property (nonatomic, strong) NSDictionary *infosCasts;
@property (nonatomic, strong) NSString *basePath;

@property (strong, nonatomic) UIImage *miniPicture;
@property (strong, nonatomic) NSString *directors;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *year;

@property (strong, nonatomic) NSDictionary *basicInfosDictionnaryFormatted;
@property (strong, nonatomic) NSDictionary *infosDictionnaryFormatted;

-(BOOL)loadBasicInfoFromTMDB;

@end
