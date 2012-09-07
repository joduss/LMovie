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

//Deprecated
#warning Méthode à supprimer
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
            else if([key isEqualToString:@"viewed"]){
                //si value est nil et key=viewed
                [dico setObject:[NSString stringWithFormat:@"%d", ViewedMAYBE] forKey:key];
            }
        }
        
        if([dico valueForKey:key] == nil){
            [dico removeObjectForKey:key];
        }
        else if([[dico valueForKey:key] respondsToSelector:@selector(isEqualToString:)] && [[dico valueForKey:key] isEqualToString:@""] ){
            [dico removeObjectForKey:key];
        }


    }
    

           
    DLog(@"dico renvoyé avec les info formatée: %@", [dico description]);
    return dico;
}


- (NSDictionary *)formattedInfoInDictionnaryWithImage:(ImageSize)imageSize{
    NSMutableDictionary *dico= [[NSMutableDictionary alloc] init];
    
    for(NSString *key in [[self.entity propertiesByName] allKeys]){
        if([key isEqualToString:@"mini_picture"] && [self valueForKey:key] != nil){
            if(imageSize != ImageSizeBig){
                [dico setObject:[UIImage imageWithData:self.mini_picture] forKey:@"mini_picture"];
            }
        }
        else if([key isEqualToString:@"big_picture"] && [self valueForKey:key] != nil){
            if(imageSize != ImageSizeMini){
                [dico setObject:[UIImage imageWithData:self.big_picture] forKey:@"big_picture"];
            }
        }
        else {
            NSString *value = [[self valueForKey:key] description];
            if(value != nil){
                [dico setObject:value forKey:key];
                DLog(@"value in Movie+Info: %@ for key: %@", value, key);
            }
        }
        
        if([dico valueForKey:key] == nil){
            [dico removeObjectForKey:key];
        }
        else if([[dico valueForKey:key] respondsToSelector:@selector(isEqualToString:)] && [[dico valueForKey:key] isEqualToString:@""] ){
            [dico removeObjectForKey:key];
        }
        
        
    }
    
    
    
    DLog(@"dico renvoyé avec les info formatée: %@", [dico description]);
    return dico;
}




-(void)setPictureWithBigPicture:(UIImage *)image
{
    UIImage *mini_image = [utilities resizeImageToMini:image];
    UIImage *big_image = [utilities resizeImageToBig:image];
    [self setBig_picture:UIImagePNGRepresentation(big_image)];
    [self setMini_picture:UIImagePNGRepresentation(mini_image)];
}



@end
