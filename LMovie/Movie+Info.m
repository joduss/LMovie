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
        if([key isEqualToString:@"mini_picture"] && [self valueForKey:key] != nil){
            [dico setObject:[UIImage imageWithData:self.mini_picture] forKey:@"mini_picture"];
        }
        else if([key isEqualToString:@"big_picture"] && [self valueForKey:key] != nil){
            [dico setObject:[UIImage imageWithData:self.big_picture] forKey:@"big_picture"];
        }
        else {
            NSString *value = [[self valueForKey:key] description];
            if(value != nil){
                [dico setObject:value forKey:key];
                DLog(@"value in Movie+Info: %@ for key: %@", value, key);
            }
        }
    }

           
    DLog(@"dico renvoyé avec les info formatée: %@", [dico description]);
    return dico;
}
@end
