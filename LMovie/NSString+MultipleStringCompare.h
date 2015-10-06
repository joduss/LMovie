//
//  NSString+MultipleStringCompare.h
//  LMovie
//
//  Created by Jonathan Duss on 05.09.12.
//
//

#import <Foundation/Foundation.h>

@interface NSString (MultipleStringCompare)

/// Compares several string to the current string and return true if one matches
- (BOOL)isEqualToAnyString:(NSString *)firstString, ... NS_REQUIRES_NIL_TERMINATION;
@end
