//
//  NSString+NumberConvert.m
//  LMovieB
//
//  Created by Jonathan Duss on 11.02.13.
//
//

#import "NSString+NumberConvert.h"

@implementation NSString (NumberConvert)

#pragma mark - converter
-(NSNumber *)nsNumber{
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];

    
    return [nf numberFromString:self];
}


@end
