//
//  Movie+Info.m
//  LMovie
//
//  Created by Jonathan Duss on 16.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Movie+Info.h"


@implementation Movie (Info)



//Retourne les valeurs pour toutes les clés + avec les images de taille désirée, SANS tmdb_ID !!!

- (NSDictionary *)formattedInfoInDictionnaryWithImage:(ImageSize)imageSize{
    
    //[self verifyData];
    
    
    NSMutableDictionary *dico= [[NSMutableDictionary alloc] init];
    NSMutableArray *keys = [[[self.entity propertiesByName] allKeys] mutableCopy];
    [keys removeObject:@"cover"];
    
    
    for(NSString *key in keys){
        
        
        /*dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if([key isEqualToString:@"mini_picture"] && [self valueForKey:key] != nil){
                if(imageSize != ImageSizeBig){
                    
                    [dico setObject:[UIImage imageWithData:self.mini_picture] forKey:@"mini_picture"];
                }
            }
        });*/
        
        /*if([key isEqualToString:@"big_picture"] && [self valueForKey:key] != nil){
            if(imageSize != ImageSizeMini){
                [dico setObject:[UIImage imageWithData:self.big_picture] forKey:@"big_picture"];
            }
        }*/
        if ([key isEqualToAnyString:@"", nil]){
            //nothing
        }
        else {
            NSString *value = [[self valueForKey:key] description];
            if(value != nil){
                [dico setObject:value forKey:key];
                DLog2(@"value in Movie+Info: %@ for key: %@", value, key);
            }
        }

        
        
    }
    
    //On supprime l'image non voulue
    if(imageSize == ImageSizeBig){
        [dico setObject:[self big_cover] forKey:@"big_cover"];
    } else if(imageSize == ImageSizeMini){
        [dico setObject:[self mini_cover] forKey:@"mini_cover"];
    }
    
    
    
    DLog2(@"dico renvoyé avec les info formatée: %@", [dico description]);
    return dico;
}



-(UIImage *)big_cover{
    Cover *covers = (Cover *)[self cover];
    return [UIImage imageWithData:covers.big_cover];
}

-(UIImage *)mini_cover{
    Cover *covers = (Cover *)[self cover];
    return [UIImage imageWithData:covers.mini_cover];
}

-(void)setCoversWithData:(NSData*)data{

    UIImage *originalImage = [UIImage imageWithData:data];
    [self setCoversWithImage:originalImage];
}

-(void)setCoversWithImage:(UIImage *)image{
    Cover *covers = (Cover *)[self cover];

    UIImage *mini_image = [utilities resizeImageToMini:image];
    UIImage *big_image = [utilities resizeImageToBig:image];
    
    [covers setBig_cover:UIImagePNGRepresentation(big_image)];
    [covers setMini_cover:UIImagePNGRepresentation(mini_image)];
}






/*
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
*/

#pragma mark - test validité des données
/*
-(void)verifyData{
    if([self audit]>0){
        [self recovery];
        if([self audit]>0){
#warning gérer le cas
        } else {
            [[self managedObjectContext] save:nil]; //on enregistre le contexte
#warning gérer si erreur d'enregistrement
        }
    }
}

-(int)audit{
    int error = 0;
    error += [self testPictures];
    
    return error;
}

-(int)testPictures{
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    if([mgr fileExistsAtPath:[self big_picture] isDirectory:NO] == NO){
        return 1;
    }
    if([mgr fileExistsAtPath:[self mini_picture_path] isDirectory:NO] == NO){
        return 1;
    }
    return 0;
}


-(void)recovery{
    NSFileManager *mgr = [NSFileManager defaultManager];

    if([self testPictures] > 0){
        //au moins une image n'existe pas, par sécurité on supprime les 2
        [mgr removeItemAtPath:[self big_picture_path] error:nil];
        [mgr removeItemAtPath:[self mini_picture_path] error:nil];
        
        //remet l'image par défaut
        [self setBig_picture_path:[MovieManagerUtils defaultBigPicturePath]];
        [self setMini_picture_path:[MovieManagerUtils defaultMiniPicturePath]];

    }
}
 
 */


-(NSString *)description{
    return [NSString stringWithFormat:@"MOVIE: %@, year: %@", self.title, self.year];
}


- (void) revertChanges {
    // Revert to original Values
    NSDictionary *changedValues = [self changedValues];
    NSDictionary *committedValues = [self committedValuesForKeys:[changedValues allKeys]];
    NSEnumerator *enumerator;
    id key;
    enumerator = [changedValues keyEnumerator];
    
    while ((key = [enumerator nextObject])) {
        NSLog(@"Reverting field ""%@"" from ""%@"" to ""%@""", key, [changedValues objectForKey:key], [committedValues objectForKey:key]);
        [self setValue:[committedValues objectForKey:key] forKey:key];
    }
}




@end
