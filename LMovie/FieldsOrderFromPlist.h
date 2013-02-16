//
//  FieldsOrderFromPlist.h
//  LMovieB
//
//  Created by Jonathan Duss on 02.02.13.
//
//

#import <Foundation/Foundation.h>

@interface FieldsOrderFromPlist : NSObject
@property (readonly, strong) NSArray *allKey;
@property (readonly, strong) NSArray *keyOrderedBySection;

-(NSArray *)keyOrderedBySection;


-(NSString *)keyAtIndexPath:(NSIndexPath *)path;
/**
 Return the section in which a key should be in the MovieInfoTVC
 @param key the key we want to know the section
 @return the section
 */
-(int)sectionForKey:(NSString *)key;
-(NSString *)labelForKey:(NSString *)key;

/**
 Return the key in the order it should be displayed in the TableView showing all info about a movie
 @return An array with the key in the correct order
 */
-(NSArray *)orderedKey;

/**
 Return the associated placeholder
 @param key the key for which we want the placeholder
 @return the placeholder value
 */
-(NSString *)placeholderForKey:(NSString *)key;


@end
