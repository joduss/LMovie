//
//  MasterInfoControler.m
//  LMovie
//
//  Created by Jonathan Duss on 19.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MasterInfoControler.h"

@interface MasterInfoControler ()

@end

@implementation MasterInfoControler
@synthesize boutonTestMaster;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setBoutonTestMaster:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if(self.view == nil)
        self.view = [[UIView alloc] init];
    
}



- (IBAction)Ajouter1SurDetailView:(id)sender {
}



- (void) addOneOnDetail{
    double new = [self.boutonTestMaster.titleLabel.text doubleValue] + 1; 
    self.boutonTestMaster.titleLabel.text = [NSString stringWithFormat:@"%d", new];
}

@end
