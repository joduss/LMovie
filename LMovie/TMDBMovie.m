//
//  TMDBMovie.m
//  LMovie
//
//  Created by Jonathan Duss on 25.08.12.
//
//

#import "TMDBMovie.h"


@interface TMDBMovie()
@end

@implementation TMDBMovie

-(id)initWithMovieID:(NSString *)movieID
{
    self = [super init];
    self.movieID = movieID;
    return self;
}


/**
 Load basic information for that movie (title, cast, other information about the movie and with small poster image)
 
 @return true when loading is over
 */
-(BOOL)loadBasicInfoFromTMDB
{
    int try = 3;
    BOOL succes = YES;
    
    for(int n = 0; n<=try; n++){
        
        @try {
            
            NSString *language = [[SettingsLoader settings] appLanguage];
            
            language = [language uppercaseString];
            
            NSURL *castsUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.themoviedb.org/3/movie/%@/casts?api_key=%@", _movieID, TMDB_API_KEY]];
            NSData *castJsonData = [NSData dataWithContentsOfURL:castsUrl];
            _infosCasts = [NSJSONSerialization JSONObjectWithData:castJsonData options:kNilOptions error:nil];
            DLog(@"castsURL: %@", [castsUrl description]);
            
            
            NSURL *generalUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.themoviedb.org/3/movie/%@?api_key=%@&language=%@", _movieID, TMDB_API_KEY, language]];
            NSData *generalJsonData = [NSData dataWithContentsOfURL:generalUrl];
            
            DLog(@"generalURL: %@", [generalUrl description]);
            
            _infosGeneral = [NSJSONSerialization JSONObjectWithData:generalJsonData options:kNilOptions error:nil];
            DLog(@"_infoGenelra: %@", [_infosGeneral description]);
            
            
            NSString *miniPicturePath = [self.basePath stringByAppendingFormat:@"/w150%@?api_key=%@",[_infosGeneral valueForKey:@"poster_path"],TMDB_API_KEY];
            _miniPicture = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:miniPicturePath]]];
            DLog(@"image path: %@", miniPicturePath);
            
            succes = YES;
        }
        @catch (NSException *exception) {
            succes = NO;
        }
        @finally {
            if(succes){
                return true;
            }
        }
        
        return false;
        
    }
}


-(NSString *)basePath
{
//base path to get from tmdb api
    return @"http://cf2.imgobject.com/t/p";
}


-(NSString *)directors{

    NSArray *crew = [_infosCasts valueForKey:@"crew"];
    
    
    NSMutableArray *directors = [[NSMutableArray alloc] init];
    
    for(NSDictionary *member in crew){
        if([[member valueForKey:@"job"] isEqualToString:@"Director"]){
            [directors addObject:[member valueForKey:@"name"]];
        }
    }

    NSString *directorsString = [utilities stringFromArray:directors];
    return directorsString;
}


-(NSString *)title{
    
    /*if(_title == nil){
        if([[SettingsLoader settings] language] == LMLanguageFrench)
        {
            NSURL *alternativeTitlesUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.themoviedb.org/3/movie/%@/alternative_titles?api_key=%@", _movieID, TMDB_API_KEY]];
            NSData *alternativeTitlesJsonData = [NSData dataWithContentsOfURL:alternativeTitlesUrl];
            DLog(@"castsURL: %@", [alternativeTitlesUrl description]);
            
            
            NSDictionary *alternativeTitlesDico = [NSJSONSerialization JSONObjectWithData:alternativeTitlesJsonData options:kNilOptions error:nil];
            
            NSString *title = [alternativeTitlesDico objectForKey:@"FR"];
            DLog(@"titre alternatifs: %@", alternativeTitlesDico);
            
            if(title == nil){
                _title = [_infosGeneral valueForKey:@"original_title"];
            }
            else
            {
                _title = title;
            }
            
        }
        else
        {*/
    if(_title == nil)
    {
            _title = [_infosGeneral valueForKey:@"title"];
        if(_title == nil){
            _title = [_infosGeneral valueForKey:@"original_title"];
        }
    }
        //}
    //}
    return _title;
}


-(NSString *)year
{
    if([_infosGeneral valueForKey:@"release_date"] != [NSNull null]){
        NSArray *yearDecomposed;
        DLog(@"bla connard de merde: %@", [_infosGeneral valueForKey:@"release_date"]);
        yearDecomposed = [[_infosGeneral valueForKey:@"release_date"] componentsSeparatedByString:@"-"];
        return [yearDecomposed objectAtIndex:0];
    }
    else{
        return nil;
    }
}


/** Returns a dictionary with the basic information for a movie (title, year, director) */
-(NSDictionary *)basicInfosDictionnaryFormatted
{
    if(_basicInfosDictionnaryFormatted == nil){
        NSMutableDictionary *info = [[NSMutableDictionary alloc] init];

        [info setObject:self.title forKey:@"title"];
        [info setObject:self.year forKey:@"year"];
        [info setObject:self.directors forKey:@"director"];
            
        _basicInfosDictionnaryFormatted = info;
    }
    return _basicInfosDictionnaryFormatted;
}


/** Returns a dic with all information about the movie (title, year, cast, genres, rating, poster) */
-(NSDictionary *)infosDictionnaryFormatted
{
    if(_infosDictionnaryFormatted == nil)
    {
        UIImage *big_picture;
        NSString *genre;
        NSString *actors;

        
        
        //Load Big_Picture
        NSString *picturePath = [self.basePath stringByAppendingFormat:@"/w500%@?api_key=%@",[_infosGeneral valueForKey:@"poster_path"],TMDB_API_KEY];        
        big_picture = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:picturePath]]];
        
        //load genre
        NSArray *rawGenreArray = [self.infosGeneral objectForKey:@"genres"];
        NSMutableArray *genreArray = [NSMutableArray array];
        for(NSDictionary *dico in rawGenreArray){
            [genreArray addObject:[dico valueForKey:@"name"]];
        }
        genre = [utilities stringFromArray:genreArray];
        
        //Load actors
        NSArray *actorsArray = [_infosCasts valueForKey:@"cast"];
        actors = [utilities stringFromArray:actorsArray];
        
        NSArray *rawActorArray = [self.infosCasts objectForKey:@"cast"];
        NSMutableArray *actorArray = [NSMutableArray array];
        for(NSDictionary *dico in rawActorArray){
            [actorArray addObject:[dico valueForKey:@"name"]];
        }
        actors = [utilities stringFromArray:actorArray];
        
        
        
        
        
        
        NSMutableDictionary *info = [[NSMutableDictionary alloc] init];

        [info setObjectWithNilControl:big_picture forKey:@"big_picture"];
        [info setObjectWithNilControl:self.title forKey:@"title"];
        [info setObjectWithNilControl:[NSString stringWithFormat:@"%@", self.year] forKey:@"year"];
        [info setObjectWithNilControl:[NSString stringWithFormat:@"%@",[self.infosGeneral valueForKey:@"runtime"] ] forKey:@"duration"];
        [info setObjectWithNilControl:genre forKey:@"genre"];
        [info setObjectWithNilControl:[self.directors description] forKey:@"director"];
        [info setObjectWithNilControl:actors forKey:@"actors"];
        [info setObjectWithNilControl:[NSString stringWithFormat:@"%@",[self.infosGeneral valueForKey:@"vote_average"]] forKey:@"tmdb_rate"];
        [info setObjectWithNilControl:[NSString stringWithFormat:@"%@",[_infosGeneral valueForKey:@"id"]] forKey:@"tmdb_ID"];
        
        
        _infosDictionnaryFormatted = info;

    }
    
    return _infosDictionnaryFormatted;
}


@end
