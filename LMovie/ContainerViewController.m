//
//  ContainerViewController.m
//  LMovieB
//
//  Created by Jonathan Duss on 25.07.13.
//
//

#import "ContainerViewController.h"

@interface ContainerViewController ()
-(void)empty;
@end



@implementation ContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_delegate containerWillbeFilled];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self empty];
    
    [self addChildViewController:segue.destinationViewController];
    ((UIViewController *)segue.destinationViewController).view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:((UIViewController *)segue.destinationViewController).view];
    [segue.destinationViewController didMoveToParentViewController:self];
    
    [_delegate containerWillbeFilled];
}

-(void)empty
{
    for(UIViewController *vc in self.childViewControllers){
        [vc removeFromParentViewController];
    }
    for(UIView *view in self.view.subviews){
        [view removeFromSuperview];
    }
}

-(void)resetContainer
{
    [_delegate containerWillBeEmpty];
    [self empty];
}

@end