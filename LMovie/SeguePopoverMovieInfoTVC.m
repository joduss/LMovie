//
//  SeguePopoverMovieInfoTVC.m
//  LMovie
//
//  Created by Jonathan Duss on 16.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SeguePopoverMovieInfoTVC.h"



@implementation SeguePopoverMovieInfoTVC
@synthesize rec = _rec;


-(id)initWithIdentifier:(NSString *)identifier source:(UIViewController *)source destination:(UIViewController *)destination{
    self = [super initWithIdentifier:identifier source:source destination:destination];
    return self;
}

-(void)perform
{
    int weightOfPopoverView = 350;
    MovieInfoTVC *view = [[[self destinationViewController] childViewControllers] lastObject];
    int height = [[self sourceViewController] view].window.frame.size.height;
    
    
    [view setContentSizeForViewInPopover:CGSizeMake(weightOfPopoverView, height)];
    
    UIPopoverController *pc = [[UIPopoverController alloc] initWithContentViewController:[self destinationViewController]];
    [pc setPopoverContentSize:CGSizeMake(weightOfPopoverView, height)];
    
    //[pc setPassthroughViews:[NSArray arrayWithObject:self.tableView]];
    
    CGRect a = _rec;
    
    DLog(@"%f, %f, %f, %f", a.origin.x, a.origin.y, a.size.width, a.size.height);
    
    UIView *sourceView = [[self sourceViewController] tableView];
    view.popover = pc;
    
    [pc presentPopoverFromRect:CGRectMake(a.origin.x, a.origin.y, a.size.width-weightOfPopoverView-10, a.size.height) inView:sourceView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    
    
    DLog(@"ok");   
}
@end

/*-
 
 Movie *movie = [_fetchedResultsController objectAtIndexPath:[_tableView indexPathForSelectedRow]];
 [view setMovie:movie];
 view.movieManager = self.movieManager;

 
 */
