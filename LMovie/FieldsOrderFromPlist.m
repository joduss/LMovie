//
//  FieldsOrderFromPlist.m
//  LMovieB
//
//  Created by Jonathan Duss on 02.02.13.
//
//

#import "FieldsOrderFromPlist.h"
 
@interface FieldsOrderFromPlist ()
@property (nonatomic, strong) NSDictionary *plist;
-(NSDictionary *)loadPlistValueOfKey:(NSString *)key;

@end




@implementation FieldsOrderFromPlist
@synthesize allKey = _allKey;
@synthesize plist = _plist;
@synthesize keyOrderedBySection = _keyOrderedBySection;


#pragma mark - gestion des clé, de leur ordre, section associée etc
/*
 On se base sur Keys.plist. Ce Plist définit le nom des clés (qui sont ceux définit dans CoreData), et on leur associe:
 - un ordre selon l'affichage que l'on veut dans nos TableView
 - une section
 - les placeholder (FR et EN) à mettre
 - les "labels" (FR et EN) (label: genre si on a "Sous-titre: FR, EN", Sous-titre et le label)
 */


//Retourne soit le dico de la section associée à une variable d'un film, soit de l'ordre

-(NSDictionary *)plist{
    DLog(@"PLIST ACCESS");
    if(_plist == nil){
        NSString *file = [[NSBundle mainBundle] pathForResource:@"Keys" ofType:@"plist"];
        NSDictionary *dico = [NSDictionary dictionaryWithContentsOfFile:file];
        _plist = dico;
    }
    return _plist;
}


-(NSDictionary *)loadPlistValueOfKey:(NSString *)key
{
    DLog2(@"PLIST: %@", _plist);
    return [_plist valueForKey:key];
}


-(NSArray *)orderedKey
{
    return (NSArray *)[self loadPlistValueOfKey:@"order"];
}

-(NSArray *)keyOrderedBySection{
    if(_keyOrderedBySection == nil){
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
        
        _keyOrderedBySection = [indexPathOrdered copy];
    }
    return _keyOrderedBySection;
    
}


-(NSString *)keyAtIndexPath:(NSIndexPath *)path
{
    return [[[self keyOrderedBySection] objectAtIndex:path.section] objectAtIndex:path.row];
}


-(int)sectionForKey:(NSString *)key{
    NSDictionary *dico = [self loadPlistValueOfKey:@"section"];
    return [[dico valueForKey:key] floatValue];
}

-(NSString *)labelForKey:(NSString *)key
{
    DLog(@"langue label for key in MOVIEMANAGER: %@", [[SettingsLoader settings] language]);
    
    if([[[SettingsLoader settings] language] isEqualToString:@"fr"]){
        return [[self loadPlistValueOfKey:@"label-fr"] valueForKey:key];
    }
    return [[self loadPlistValueOfKey:@"label"] valueForKey:key];
}



-(NSString *)placeholderForKey:(NSString *)key
{
    
    DLog(@"langue placeholder: %@", [[SettingsLoader settings] language]);
    
    if([[[SettingsLoader settings] language] isEqualToString:@"fr"]){
        return [[self loadPlistValueOfKey:@"placeholder-fr"] valueForKey:key];
    }
    return [[self loadPlistValueOfKey:@"placeholder"] valueForKey:key];
}



@end
