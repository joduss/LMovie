//
//  PanelSegue.m
//  LMovie
//
//  Created by Jonathan Duss on 15.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PanelSegue.h"

@implementation PanelSegue

-(id)initWithIdentifier:(NSString *)identifier source:(UIViewController *)source destination:(UIViewController *)destination
{
    self = [super initWithIdentifier:identifier source:source destination:destination];
    return self;
}

-(void)perform
{
    int viewWidth = 320;
    
    MovieViewController* mvc =  self.sourceViewController;
    int mvcWidth = mvc.view.frame.size.width;
    int mvcHeigth = mvc.view.frame.size.height;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(mvcWidth, 0, viewWidth, mvcHeigth)];
    
    [mvc.view addSubview:view];
    
    
    //UIView *view = [[infoViewPanel alloc] init];
    DLog(@"%@", [[[NSBundle mainBundle] loadNibNamed:@"infoView" owner:self options:nil]description]);
    infoViewPanel* destView = [[infoViewPanel alloc] init];
    
    destView.frame = CGRectMake(0, 0, viewWidth, mvcHeigth);
    destView.bounds = CGRectMake(0, 0, viewWidth, mvcHeigth);
    
    

    
    int originWhenVisible = mvcWidth - viewWidth;

           [view addSubview:destView];
    
    actionBlock action = ^(){
        [ mvc.navigationItem.rightBarButtonItem setAction:nil];
        [UIView animateWithDuration:0.5 animations:^{
            [view setFrame:CGRectMake(mvcWidth, 0, viewWidth, mvcHeigth)];
        } completion:^(BOOL finished){[view removeFromSuperview];}];
        
        [mvc.navigationItem setRightBarButtonItems:nil animated:YES]; 
    };
    
   
        
 BarButtonBlocks *button = [[BarButtonBlocks alloc] initWithTitle:@"Hide" style:UIBarButtonItemStyleBordered action:action];
    mvc.navigationItem.rightBarButtonItem = button;
    
    
 
    
    [UIView animateWithDuration:0.5 
                     animations:^{
                             [view setFrame:CGRectMake(originWhenVisible, 0, viewWidth, mvcHeigth)];
                         }];
    
      

}
@end
