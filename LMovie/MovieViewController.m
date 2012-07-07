//
//  MovieViewController.m
//  LMovie
//
//  Created by Jonathan Duss on 02.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovieViewController.h"

@interface MovieViewController ()

@end

@implementation MovieViewController
@synthesize connard = _connard;
@synthesize detailPanel = _connard2;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    [_connard2 setOpaque:NO];
    _connard2.alpha = 0;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self.navigationController navigationBar] setBarStyle:UIBarStyleBlack];
    [[self.navigationController toolbar] setBarStyle:UIBarStyleBlackOpaque ];

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
    
    
    [_connard2 setBounds:CGRectMake(0, 0, 20, 10)];
    
    [self.view addSubview:_connard2];
    [_connard2 setFrame:CGRectMake(0, 0, 100, 400)];
    
    
    /*[UIView animateWithDuration:0.5 animations:^{
        if(_connard2.alpha >= 0.8){
            _connard2.alpha = 0.0;
        }
        else if (_connard2.alpha <= 0) {
            _connard2.alpha = 0.8;
        }
    }];*/
}



@end
