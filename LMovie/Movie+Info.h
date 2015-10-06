//
//  Movie+Info.h
//  LMovie
//
//  Created by Jonathan Duss on 16.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Movie.h"
#import "NSString+MultipleStringCompare.h"


/**
 State of the value: Viewed, which represent if a movie has already be viewed or not.
 */
typedef enum {
    /** Movie not viewed*/
    ViewedNO = 0,
    ViewedYES = 1,
    ViewedMAYBE = 2,
    ViewedAll = 3 //utilisée uniquement pour la recherche
} ViewedState;

typedef enum {
    ImageSizeBig = 0,
    ImageSizeMini = 1,
    ImageSizeBigAndMini = 2
} ImageSize;


/**
Represent a MOVIE.
 Add some useful function for the Movie class
 
 */
@interface Movie (Info)
/**
 Retourne les informations du Movie, avec une image de taille donnée en paramètre. TMDB_ID n'est cependant pas inclus dans ces informations
 @param imageSize taille de l'image que l'on veut
 @return Le dictionnaire d'informations
 */
- (NSDictionary *)formattedInfoInDictionnaryWithImage:(ImageSize)imageSize;
-(void)setPicturesWithBigPicture:(UIImage *)image;
@end





