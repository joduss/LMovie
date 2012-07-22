//
//  Movie+Info.m
//  LMovie
//
//  Created by Jonathan Duss on 16.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Movie+Info.h"
#import "MovieManager.h"

@implementation Movie (Info)
- (NSDictionary *)formattedInfoInDictionnary{
    NSMutableDictionary *dico= [[NSMutableDictionary alloc] init];
      
    for(NSString *key in [[self.entity propertiesByName] allKeys]){
        if([key isEqualToString:@"picture"] && [self valueForKey:key] != nil){
            [dico setObject:[UIImage imageWithData:self.picture] forKey:@"picture"];
        }
        else {
            NSString *value = [[self valueForKey:key] description];
            if(value != nil){
                [dico setObject:value forKey:key];
            }
        }
    }

           
    DLog(@"dicodico: %@", [dico description]);
    return dico;
}
@end
