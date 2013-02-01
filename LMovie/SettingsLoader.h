//
//  SettingsLoader.h
//  LMovie
//
//  Created by Jonathan Duss on 07.09.12.
//
//

#import <Foundation/Foundation.h>





@interface SettingsLoader : NSObject
-(NSString *)appLanguage;
-(void)changeAppLanguageToLanguage:(NSString *)language;

+(SettingsLoader *)settings;

@property (nonatomic, strong) NSString * language;

@end



