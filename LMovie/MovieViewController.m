//
//  MovieViewController.m
//  LMovie
//
//  Created by Jonathan Duss on 02.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovieViewController.h"

@interface MovieViewController ()
@property BOOL panelUsed;
@end

@implementation MovieViewController
@synthesize connard = _connard;
@synthesize detailPanel = _connard2;
@synthesize panelUsed = _panelUsed;



- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self.navigationController navigationBar] setBarStyle:UIBarStyleBlack];
    [[self.navigationController toolbar] setBarStyle:UIBarStyleBlackOpaque ];
    _panelUsed = NO;


	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setConnard:nil];
    [self setConnard:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (IBAction)fuck:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryBoard" bundle:nil];
    __block UIViewController* controller = [storyboard instantiateViewControllerWithIdentifier:@"test2"];
    UIView *view = [controller.view viewWithTag:10];

    int bw = view.bounds.size.width;
    int bh = view.bounds.size.height;
    int px = self.view.frame.size.width - bw;
    //int py = self.view.frame.size.height;
    if(_panelUsed == NO){
    [_connard2 setFrame:CGRectMake(px+bw, 0, bw, bh)];
    [view setFrame:CGRectMake(0, 0, bw, bh)];

    
   
    for(UIView *v in _connard2.subviews){
        [v removeFromSuperview];
    }
        
    
   /* NSLog(@"frame: origine:(%f, %f), size:(%f,%f)",view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    NSLog(@"bounds:origine:(%f, %f), size:(%f,%f)", view.bounds.origin.x, view.bounds.origin.y, view.bounds.size.width, view.bounds.size.height  );
    
    NSLog(@"_connard frame: origine:(%f, %f), size:(%f,%f)",_connard2.frame.origin.x, _connard2.frame.origin.y, _connard2.frame.size.width, _connard2.frame.size.height);
    NSLog(@"_connard bounds:origine:(%f, %f), size:(%f,%f)", _connard2.bounds.origin.x, _connard2.bounds.origin.y, _connard2.bounds.size.width, _connard2.bounds.size.height  );*/
        
        [_connard2 addSubview:view];
        [_connard2 setNeedsDisplay];
        //[self.view addSubview:_connard2];
        //[_connard2 setFrame:CGRectMake(0, 0, 100, 400)];
        
    }
    
    void (^unload2)(BOOL) = ^(BOOL finished){
        if(finished && _panelUsed == NO){
            [controller viewDidUnload];
            controller = nil;
            for(UIView *v in _connard2.subviews){
                [v removeFromSuperview];
            }
        }
    }; 
    
    [UIView animateWithDuration:0.5 
                     animations:^{
                         if(_panelUsed == NO){
                             [_connard2 setFrame:CGRectMake(px, 0, bw, bh)];
                             _panelUsed = YES;
                         }
                         else {
                             [_connard2 setFrame:CGRectMake(px+bw, 0, bw, bh)];
                             _panelUsed = NO;
                             
                         }
                     }
                     completion:unload2];
    
}



@end
