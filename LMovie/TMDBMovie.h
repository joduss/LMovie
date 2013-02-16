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
#import "MovieManagerUtils.h"
#import "Movie+Info.h"
#import "NSString+NumberConvert.h"


@interface TMDBMovie : NSObject

-(id)initWithMovieID:(NSString *)movieID;

@property (nonatomic, strong) NSString *movieID;
@property (nonatomic, strong) NSDictionary *infosGeneral;
@property (nonatomic, strong) NSDictionary *infosCasts;
@property (nonatomic, strong) NSString *basePath;

@property (strong, nonatomic) UIImage *miniCover;
-(NSString *)directors;
-(NSString *)title;
- (NSString *)year;

@property (strong, nonatomic) NSDictionary *basicInfosDictionnaryFormatted;
@property (strong, nonatomic) NSDictionary *infosDictionnaryFormatted;

-(BOOL)loadBasicInfoFromTMDB;

-(void)completeInfoForMovie:(Movie *)movie;


@end
