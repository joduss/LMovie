//
//  SharedManager.m
//  LMovieB
//
//  Created by Jonathan Duss on 01.02.13.
//
//

#import "SharedManager.h"

@implementation SharedManager

@synthesize emptyStar = _emptyStar;
@synthesize halfStar = _halfStar;
@synthesize fullStar = _fullStar;
@synthesize viewedIconMAYBE = _viewedIconMAYBE;
@synthesize viewedIconNO = _viewedIconNO;
@synthesize viewedIconYES = _viewedIconYES;

static SharedManager *sharedManager = nil;

+ (id)getInstance {
    @synchronized(self) {
        if (sharedManager == nil)
            sharedManager = [[self alloc] init];
    }
    return sharedManager;
}

-(UIImage *)emptyStar{
    if(_emptyStar == nil){
        _emptyStar = [UIImage imageNamed:@"empty.png"];
    }
    return  _emptyStar;
}

-(UIImage *)halStar{
    if(_halfStar == nil){
        _halfStar = [UIImage imageNamed:@"middle.png"];
    }
    return  _halfStar;
}

-(UIImage *)fullStar{
    if(_fullStar == nil){
        _fullStar = [UIImage imageNamed:@"full.png"];
    }
    return  _fullStar;
}

-(UIImage *)viewedIconYES{
    if(_viewedIconYES == nil){
        NSString *file = [[NSBundle mainBundle] pathForResource:@"Vu" ofType:@"png"];
        _viewedIconYES = [UIImage imageWithContentsOfFile:file];
    }
    return _viewedIconYES;
}

-(UIImage *)viewedIconNO{
    if(_viewedIconYES == nil){
        NSString *file = [[NSBundle mainBundle] pathForResource:@"PasVu" ofType:@"png"];
        _viewedIconNO = [UIImage imageWithContentsOfFile:file];
    }
    return _viewedIconNO;
}

-(UIImage *)viewedIconMAYBE{
    if(_viewedIconYES == nil){
        NSString *file = [[NSBundle mainBundle] pathForResource:@"VuNoIdea" ofType:@"png"];
        _viewedIconMAYBE = [UIImage imageWithContentsOfFile:file];
    }
    return _viewedIconMAYBE;
}

-(UIImage *)viewedIcon:(ViewedState)viewedState{
    UIImage *icon;
    switch (viewedState) {
        case ViewedNO:
            icon = _viewedIconNO;
            break;
        case ViewedYES:
            icon = _viewedIconYES;
            break;
        default:
            icon = _viewedIconMAYBE;
            break;
    }
    return icon;
}



@end
