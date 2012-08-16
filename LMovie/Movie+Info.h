//
//  Movie+Info.h
//  LMovie
//
//  Created by Jonathan Duss on 16.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Movie.h"

@interface Movie (Info)
- (NSDictionary *)formattedInfoInDictionnary;
@end


typedef enum {
    ViewedNO = 0,
    ViewedYES = 1,
    ViewedMAYBE = 2,
    ViewedAll = 3 //utilisée uniquement pour la recherche
} ViewedState;


