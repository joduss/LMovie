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


//Perform le segue et place le popover sur la droite. La largueur de la zone permise est automatiquement prise de la taille de la concentView prise depuis les valeurs entrée dans le Storyboard
-(void)perform
{
    
    MovieInfoTVC *vc = [[[self destinationViewController] childViewControllers] lastObject];
   
    
    UIPopoverController *pc = [[UIPopoverController alloc] initWithContentViewController:[self destinationViewController]];

    
    CGRect a = _rec;
    
    
    UIView *sourceView = [[self sourceViewController] tableView];
    int widthDest = vc.contentSizeForViewInPopover.width;
        
    vc.popover = pc;
    
    
    [pc presentPopoverFromRect:CGRectMake(a.origin.x, a.origin.y, a.size.width-widthDest, a.size.height) inView:sourceView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    
}
@end

/*-
 
 Movie *movie = [_fetchedResultsController objectAtIndexPath:[_tableView indexPathForSelectedRow]];
 [view setMovie:movie];
 view.movieManager = self.movieManager;

 
 */
