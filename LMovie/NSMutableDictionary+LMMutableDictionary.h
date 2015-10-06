//
//  NSMutableDictionary+LMMutableDictionary.h
//  LMovie
//
//  Created by Jonathan Duss on 02.09.12.
//
//

#import <Foundation/Foundation.h>

//Extension of NSMutableDictionary
@interface NSMutableDictionary (LMMutableDictionary)

//Add object in dictionary only if object not nil
-(void)setObjectWithNilControl:(id)anObject forKey:(id)aKey;
@end
