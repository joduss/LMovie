//
//  NSString+MultipleStringCompare.m
//  LMovie
//
//  Created by Jonathan Duss on 05.09.12.
//
//

#import "NSString+MultipleStringCompare.h"

@implementation NSString (MultipleStringCompare)

- (BOOL)isEqualToAnyString:(NSString *)firstString, ...
{
    if([self isEqualToString:firstString])
        return YES;
    
    
    va_list arguments;
    va_start(arguments, firstString);
    
    NSString *string;
    
    while((string = va_arg(arguments, NSString *)))
    {
        if([self isEqualToString:string])
        {
            va_end(arguments);
            return YES;
        }
    }
    
    va_end(arguments);
    return NO;
}

@end
