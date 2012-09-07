//
//  NSString+MultipleStringCompare.h
//  LMovie
//
//  Created by Jonathan Duss on 05.09.12.
//
//

#import <Foundation/Foundation.h>

@interface NSString (MultipleStringCompare)
- (BOOL)isEqualToAnyString:(NSString *)firstString, ... NS_REQUIRES_NIL_TERMINATION;
@end
