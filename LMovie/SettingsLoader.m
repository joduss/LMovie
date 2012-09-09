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

-(LMAppLanguage)appLanguage
{
    DLog(@"appLanguage");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *language = [defaults valueForKey:@"language"];
    

    
    DLog(@"NSNumber: %@", [language description]);
    
    if(language == nil){
        NSString * languageDevice = [[NSLocale preferredLanguages] objectAtIndex:0];
        
        if([languageDevice isEqualToString:@"fr"]){
            [defaults setValue:[NSNumber numberWithInt:LMLanguageFrench] forKey:@"language"];
            _language = LMLanguageFrench;
            DLog(@"franchais");
            
        }
        else{
            DLog(@"anglais");
            [defaults setValue:[NSNumber numberWithInt:LMLanguageEnglish] forKey:@"language"];
            _language = LMLanguageEnglish;
        }
    }else{
        _language = [language intValue];
    }
    
    DLog(@"langue après appLanguage: %d", _language);
    return _language;
}



-(void)changeAppLanguageToLanguage:(LMAppLanguage)language
{
    DLog(@"Enregistrement du changement de langue");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *languageNSNumber = [NSNumber numberWithInt:language];
    _language = language;
    
    [defaults setValue:languageNSNumber forKey:@"language"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    /*while(true){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Language change / Changement de langue"
                                                       message:@"You must quit and start again the application now to apply the change \n Vous devez quitter et relancer l'application maintenant pour appliquer le changement de langue" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }*/
    
    DLog(@"langue enregistrée: %@",[defaults valueForKey:@"language"]);
}




+(SettingsLoader *)settings
{
    if(_globalSettings == nil){
        _globalSettings = [[SettingsLoader alloc] init];
        [_globalSettings setLanguage:[_globalSettings appLanguage]];
    }
    return _globalSettings;
    
}

@end
