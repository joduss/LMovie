//
//  MovieManagerUtils.m
//  LMovieB
//
//  Created by Jonathan Duss on 03.02.13.
//
//

#import "MovieManagerUtils.h"


@interface MovieManagerUtils()
+(NSDictionary *)loadPlistValueOfKey:(NSString *)key;
@end



@implementation MovieManagerUtils

static NSArray *allKey = nil;
static NSDictionary *plist = nil;
static NSArray *keyOrderedBySection = nil ;

#pragma mark - gestion des clé, de leur ordre, section associée etc
/*
 On se base sur Keys.plist. Ce Plist définit le nom des clés (qui sont ceux définit dans CoreData), et on leur associe:
 - un ordre selon l'affichage que l'on veut dans nos TableView
 - une section
 - les placeholder (FR et EN) à mettre
 - les "labels" (FR et EN) (label: genre si on a "Sous-titre: FR, EN", Sous-titre et le label)
 */


//Retourne soit le dico de la section associée à une variable d'un film, soit de l'ordre

-(id)init{
    return self;
}

+(NSArray *)allKey{
    if(allKey == nil){
        AppDelegate *appDel = [UIApplication sharedApplication].delegate;
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Movie" inManagedObjectContext:appDel.managedObjectContext ];
        allKey = [[entity propertiesByName] allKeys];
    }
    return allKey;
}

+(NSDictionary *)plist{
    DLog(@"PLIST ACCESS");
    if(plist == nil){
        NSString *file = [[NSBundle mainBundle] pathForResource:@"Keys" ofType:@"plist"];
        NSDictionary *dico = [NSDictionary dictionaryWithContentsOfFile:file];
        plist = dico;
    }
    return plist;
}


+(NSDictionary *)loadPlistValueOfKey:(NSString *)key
{
    if(plist == nil){
        [MovieManagerUtils plist]; //initialise
    }
    DLog2(@"PLIST: %@", plist);
    return [plist valueForKey:key];
}


+(NSArray *)orderedKey
{
    return (NSArray *)[self loadPlistValueOfKey:@"order"];
}

+(NSArray *)keyOrderedBySection{
    if(keyOrderedBySection == nil){
        NSMutableArray *indexPathOrdered = [[NSMutableArray alloc] init];
        [indexPathOrdered addObject:[[NSMutableArray alloc] init]];
        [indexPathOrdered addObject:[[NSMutableArray alloc] init]];
        
        NSDictionary *sectionInfo = [self loadPlistValueOfKey:@"section"];
        NSArray *keyOrdered = (NSArray *)[self loadPlistValueOfKey:@"order"];
        
        for(NSString *key in keyOrdered){
            int section = [[sectionInfo valueForKey:key] intValue];
            [[indexPathOrdered objectAtIndex:section] addObject:key];
            //[indexPathOrdered insertObject:key atIndex:section];
        }
        
        keyOrderedBySection = [indexPathOrdered copy];
    }
    return keyOrderedBySection;
    
}


+(NSString *)keyAtIndexPath:(NSIndexPath *)path
{
    return [[keyOrderedBySection objectAtIndex:path.section] objectAtIndex:path.row];
}


+(int)sectionForKey:(NSString *)key{
    NSDictionary *dico = [self loadPlistValueOfKey:@"section"];
    return [[dico valueForKey:key] floatValue];
}


+(NSString *)labelForKey:(NSString *)key
{
    DLog(@"langue label for key in MOVIEMANAGER: %@", [[SettingsLoader settings] language]);
    
    if([[[SettingsLoader settings] language] isEqualToString:@"fr"]){
        return [[self loadPlistValueOfKey:@"label-fr"] valueForKey:key];
    }
    return [[self loadPlistValueOfKey:@"label"] valueForKey:key];
}



+(NSString *)placeholderForKey:(NSString *)key
{
    
    DLog(@"langue placeholder: %@", [[SettingsLoader settings] language]);
    
    if([[[SettingsLoader settings] language] isEqualToString:@"fr"]){
        return [[self loadPlistValueOfKey:@"placeholder-fr"] valueForKey:key];
    }
    return [[self loadPlistValueOfKey:@"placeholder"] valueForKey:key];
}

#pragma mark - Resolution number to string

+(NSString *)resolutionToStringForResolution:(LMResolution)resolution
{
    NSString *file = [[NSBundle mainBundle] pathForResource:@"MultipleChoices" ofType:@"plist"];
    NSArray *resolutionChoice = [[NSDictionary dictionaryWithContentsOfFile:file] valueForKey:[@"Resolution-"  stringByAppendingString:[[NSLocale preferredLanguages] objectAtIndex:0]]];
    
    DLog(@"réso: %@", [resolutionChoice objectAtIndex:resolution]);
    
    return [resolutionChoice objectAtIndex:resolution];
}




#pragma mark - IMAGE MANAGEMENT
//ACCES POUR IMAGES

+(NSString *)saveImageInTemporaryDirectory:(UIImage *)image{
    NSString *tempDir = NSTemporaryDirectory();
    
    double nameInDoubleWithTimeMillisSec = [NSDate timeIntervalSinceReferenceDate]*1000;
    NSString *name = [NSString stringWithFormat:@"%.0lf",nameInDoubleWithTimeMillisSec];
    
    NSString *imagePath = [tempDir stringByAppendingPathComponent:name];
    
    //parse l'image en data:
    NSError *error = nil;
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
    [imageData writeToFile:imagePath options:NSDataWritingAtomic error:&error];
    
    if(error != nil){
        NSLog(@"ERROR WRITING IMAGE");
    }
    return imagePath;
}


+(NSString *)saveImage:(UIImage *)image withName:(NSString *)name{
    double nameInDoubleWithTimeMillisSec = [NSDate timeIntervalSinceReferenceDate]*1000;
    //NSString *name = [NSString stringWithFormat:@"%.0lf",nameInDoubleWithTimeMillisSec];
    
    NSString* dir = [self imageDirectory];
    NSString *imagePath = [dir stringByAppendingPathComponent:name];
    
    //parse l'image en data:
    NSError *error = nil;
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
    [imageData writeToFile:imagePath options:NSDataWritingAtomic error:&error];
    
    if(error != nil){
        NSLog(@"ERROR WRITING IMAGE");
    }
    return imagePath;
}



+(UIImage *)loadImageAtPath:(NSString *)path{
    return [UIImage imageWithContentsOfFile:path];
}


+(NSString *) imageDirectory{
    NSFileManager *filemgr;
    NSArray *dirPaths;
    NSString *docsDir;
    
    filemgr =[NSFileManager defaultManager];
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    
    //vers images:
    docsDir = [docsDir stringByAppendingPathComponent:@"images"];
    
    
    if ([filemgr changeCurrentDirectoryPath: docsDir] == NO)
    {
        // Directory does not exist – take appropriate action
        NSString *newDir;
        
        filemgr =[NSFileManager defaultManager];
        
        dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                       NSUserDomainMask, YES);
        
        docsDir = [dirPaths objectAtIndex:0];
        newDir = [docsDir stringByAppendingPathComponent:@"images"];
        
        if ([filemgr createDirectoryAtPath:newDir withIntermediateDirectories:YES attributes:nil error: NULL] == NO)
        {
            // Failed to create directory
            ELog(@"ERROR in MOVIEMANAGERUTIL: line ");
            exit(0);
        }
        return newDir;
        
    }
    return docsDir;
    
}



#pragma mark - default values
+(NSData *)defaultBigCoverData{
    return [NSData dataWithContentsOfFile:[MovieManagerUtils defaultBigPicturePath]];
}

+(NSData *)defaultMiniCoverData{
    return [NSData dataWithContentsOfFile:[MovieManagerUtils defaultMiniPicturePath]];
}

+(NSString *)defaultBigPicturePath{
    DLog(@"Default BigPicture Path: %@", [[NSBundle mainBundle] pathForResource:@"emptyartwork_big" ofType:@"jpg"]);
    return [[NSBundle mainBundle] pathForResource:@"emptyartwork_big" ofType:@"jpg"];
}

+(NSString *)defaultMiniPicturePath{
    DLog(@"Default MiniPicture Path: %@", [[NSBundle mainBundle] pathForResource:@"emptyartwork_mini" ofType:@"jpg"]);
    return [[NSBundle mainBundle] pathForResource:@"emptyartwork_mini" ofType:@"jpg"];
}







@end
