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
@property IBOutlet UITableView *tableview;
@end

@implementation MovieViewController
@synthesize connard = _connard;
@synthesize detailPanel = _connard2;
@synthesize panelUsed = _panelUsed;
@synthesize tableview = _tableview;



- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self.navigationController navigationBar] setBarStyle:UIBarStyleBlack];
    [[self.navigationController toolbar] setBarStyle:UIBarStyleBlackOpaque ];
    _panelUsed = NO;
        
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [_connard2 setFrame:CGRectMake(0, 0, 0, 0)];
    [_connard2 setHidden:YES];
    self.title = @"LMovie";



	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setConnard:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}



- (IBAction)fuck:(id)sender {
    

    //UIView *view = [[infoViewPanel alloc] init];
    infoViewPanel* view = [[[NSBundle mainBundle] loadNibNamed:@"infoView" owner:self options:nil] objectAtIndex:0];
    


    int bw = view.bounds.size.width;
    int bh = view.bounds.size.height;
    int px = self.view.frame.size.width - bw;
    int sh = self.view.frame.size.width;
    
    NSLog(@"sh: %d", sh);
    NSLog(@"bh: %d", bh);

    
    //int py = self.view.frame.size.height;
    if(_panelUsed == NO){
    [_connard2 setFrame:CGRectMake(px+bw, 0, bw, sh)];
    //[view setFrame:CGRectMake(0, 0, bw, bh)];
        [_connard2 setContentSize:CGSizeMake(bw, bh)];
    
   
    for(UIView *v in _connard2.subviews){
        [v removeFromSuperview];
    }

    
   NSLog(@"view: , frame: origine:(%f, %f), size:(%f,%f)", view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    NSLog(@"bounds:origine:(%f, %f), size:(%f,%f)", view.bounds.origin.x, view.bounds.origin.y, view.bounds.size.width, view.bounds.size.height  );
    
    NSLog(@"_connard frame: origine:(%f, %f), size:(%f,%f)",_connard2.frame.origin.x, _connard2.frame.origin.y, _connard2.frame.size.width, _connard2.frame.size.height);
    NSLog(@"_connard bounds:origine:(%f, %f), size:(%f,%f)", _connard2.bounds.origin.x, _connard2.bounds.origin.y, _connard2.bounds.size.width, _connard2.bounds.size.height  );
        
        //[_connard2 setNeedsDisplay];
        //[self.view addSubview:_connard2];
        //[_connard2 setFrame:CGRectMake(0, 0, 100, 400)];
        
    [_connard2 addSubview:view];

        
    }
    
    void (^unload2)(BOOL) = ^(BOOL finished){
        if(finished && _panelUsed == NO){
            //[controller viewDidUnload];
            //controller = nil;
            for(UIView *v in _connard2.subviews){
                [v removeFromSuperview];
            }
            [_connard2 setHidden:YES];
        }
    }; 
    
    [UIView animateWithDuration:0.5 
                     animations:^{
                         if(_panelUsed == NO){
                             [_connard2 setHidden:NO];
                             [_connard2 setFrame:CGRectMake(px, 0, bw, sh)];
                             _panelUsed = YES;
                         }
                         else {
                             [_connard2 setFrame:CGRectMake(px+bw, 0, bw, sh)];
                             _panelUsed = NO;
                             
                         }
                     }
                     completion:unload2];
    
    NSLog(@"view: , frame: origine:(%f, %f), size:(%f,%f)", view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    NSLog(@"bounds:origine:(%f, %f), size:(%f,%f)", view.bounds.origin.x, view.bounds.origin.y, view.bounds.size.width, view.bounds.size.height  );
    
    NSLog(@"_connard frame: origine:(%f, %f), size:(%f,%f)",_connard2.frame.origin.x, _connard2.frame.origin.y, _connard2.frame.size.width, _connard2.frame.size.height);
    NSLog(@"_connard bounds:origine:(%f, %f), size:(%f,%f)", _connard2.bounds.origin.x, _connard2.bounds.origin.y, _connard2.bounds.size.width, _connard2.bounds.size.height  );

    
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"segue to new movieEditorTVC"]){
        NSLog(@"segue to newMovieEditorTVC");
        UIViewController *view = segue.destinationViewController;
        [view setContentSizeForViewInPopover:CGSizeMake(500, 500)];
        UIPopoverController *pc = [(UIStoryboardPopoverSegue *)segue popoverController];
        [pc setPopoverContentSize:CGSizeMake(500, 500)];
        
    }
        
}


/**************
 GESTION TABLEVIEW
 **************/
#pragma mark - gestion tableview

- (int)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"coucou");
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cell for row");
    NSString *identifier = @"movie cell";
    
    MovieCellHorizontal *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(cell == nil){
        NSLog(@"cell null");
    }
    
    cell.title.text = @"connard";
    
    return cell;
}










@end
