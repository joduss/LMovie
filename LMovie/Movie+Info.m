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



//Retourne les valeurs pour toutes les clés + avec les images de taille désirée, SANS tmdb_ID !!!

- (NSDictionary *)formattedInfoInDictionnaryWithImage:(ImageSize)imageSize{
    NSMutableDictionary *dico= [[NSMutableDictionary alloc] init];
    
    for(NSString *key in [[self.entity propertiesByName] allKeys]){
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if([key isEqualToString:@"mini_picture"] && [self valueForKey:key] != nil){
                if(imageSize != ImageSizeBig){
                    
                    [dico setObject:[UIImage imageWithData:self.mini_picture] forKey:@"mini_picture"];
                }
            }
        });
        
        if([key isEqualToString:@"big_picture"] && [self valueForKey:key] != nil){
            if(imageSize != ImageSizeMini){
                [dico setObject:[UIImage imageWithData:self.big_picture] forKey:@"big_picture"];
            }
        }
        else if ([key isEqualToAnyString:@"", nil]){
            //nothing
        }
        else {
            NSString *value = [[self valueForKey:key] description];
            if(value != nil){
                [dico setObject:value forKey:key];
                DLog2(@"value in Movie+Info: %@ for key: %@", value, key);
            }
        }
        
        if([dico valueForKey:key] == nil){
            [dico removeObjectForKey:key];
        }
        else if([[dico valueForKey:key] respondsToSelector:@selector(isEqualToString:)] && [[dico valueForKey:key] isEqualToString:@""] ){
            [dico removeObjectForKey:key];
        }
        
        
    }
    
    
    
    DLog2(@"dico renvoyé avec les info formatée: %@", [dico description]);
    return dico;
}




-(void)setPicturesWithBigPicture:(UIImage *)image
{
    UIImage *mini_image = [utilities resizeImageToMini:image];
    UIImage *big_image = [utilities resizeImageToBig:image];
    [self setBig_picture:UIImagePNGRepresentation(big_image)];
    [self setMini_picture:UIImagePNGRepresentation(mini_image)];
    NSError *error;
    [self.managedObjectContext save:&error];
    if(error != nil){
        DLog(@"ERROR lors de l'enregistrement du context pour l'insertion de l'image pour le film %@", self.title);
    }
    
}



@end
