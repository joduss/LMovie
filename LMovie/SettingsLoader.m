//
//  SettingsLoader.m
//  LMovie
//
//  Created by Jonathan Duss on 07.09.12.
//
//

#import "SettingsLoader.h"

@implementation SettingsLoader
static SettingsLoader *_globalSettings;
@synthesize language = _language;

-(NSString *)appLanguage
{
    DLog(@"appLanguage");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    /*if([defaults isMemberOfClass:[NSString class]] == NO){
        [defaults removeObjectForKey:@"language"];
        DLog(@"supression préference langue");
    }*/
    NSString *language = [defaults valueForKey:@"language"];
    

    
    DLog(@"Langue: %@", language);
    
    if(language == nil){
        _language = [[NSLocale preferredLanguages] objectAtIndex:0];
        [self changeAppLanguageToLanguage:_language];
        
    }else{
        _language = language;
    }
    
    DLog(@"langue après appLanguage: %@", _language);
    return _language;
}

-(void)setLanguage:(NSString *)language
{
    [self changeAppLanguageToLanguage:language];
}



-(void)changeAppLanguageToLanguage:(NSString *)language
{
    DLog(@"Enregistrement du changement de langue");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _language = language;
    
    [defaults setValue:language forKey:@"language"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    /*while(true){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Language change / Changement de langue"
                                                       message:@"You must quit and start again the application now to apply the change \n Vous devez quitter et relancer l'application maintenant pour appliquer le changement de langue" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }*/
    
    DLog(@"langue enregistrée: %@",[defaults valueForKey:@"language"]);
}



/*
 Get the sigleton instance
 */
+(SettingsLoader *)settings
{
    if(_globalSettings == nil){
        _globalSettings = [[SettingsLoader alloc] init];
        [_globalSettings setLanguage:[_globalSettings appLanguage]];
    }
    return _globalSettings;
    
}



@end
