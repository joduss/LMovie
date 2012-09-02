//
//  NSMutableDictionary+LMMutableDictionary.m
//  LMovie
//
//  Created by Jonathan Duss on 02.09.12.
//
//

#import "NSMutableDictionary+LMMutableDictionary.h"

@implementation NSMutableDictionary (LMMutableDictionary)
-(void)setObjectWithNilControl:(id)anObject forKey:(id)aKey
{
    if(anObject != nil){
        [self setObject:anObject forKey:aKey];
    }
}
@end
