//
//  SettingsLoader.h
//  LMovie
//
//  Created by Jonathan Duss on 07.09.12.
//
//

#import <Foundation/Foundation.h>


typedef enum language{
    LMLanguageEnglish = 0,
    LMLanguageFrench = 1
} LMAppLanguage;


@interface SettingsLoader : NSObject
-(LMAppLanguage)appLanguage;
-(void)changeAppLanguageToLanguage:(LMAppLanguage)language;

+(SettingsLoader *)settings;

@property (nonatomic) LMAppLanguage language;

@end



