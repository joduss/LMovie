//
//  DetailTableViewControler.m
//  LMovie
//
//  Created by Jonathan Duss on 20.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TableViewControler.h"
#import "SplitViewBarItemPresenter.h"


@interface TableViewControler ()

@end

@implementation TableViewControler
@synthesize boutonTest = _boutonTest;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.navigationController.toolbar.hidden = NO;
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setBoutonTest:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate






- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


-(id <SplitViewBarItemPresenter>)splitViewBarItemPresenter
{
    id thisV = [self.splitViewController.viewControllers lastObject];
    if(!  [thisV conformsToProtocol:@protocol(SplitViewBarItemPresenter)]){
        thisV = nil;
        
    }
    return thisV;
}


- (void) addOneDetail{
    double new = [self.boutonTest.titleLabel.text doubleValue] + 1; 
    self.boutonTest.titleLabel.text = [NSString stringWithFormat:@"%d", new];
}


- (void) splitViewController:(UISplitViewController *)svc 
      willHideViewController:(UIViewController *)aViewController 
           withBarButtonItem:(UIBarButtonItem *)barButtonItem 
        forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = self.title;
    [self splitViewBarItemPresenter].splitViewBarItem = barButtonItem;
}


- (BOOL) splitViewController:(UISplitViewController *)svc 
    shouldHideViewController:(UIViewController *)vc 
               inOrientation:(UIInterfaceOrientation)orientation
{
    return [self splitViewBarItemPresenter] ? /*YES*/ UIInterfaceOrientationIsPortrait(orientation) : NO;  
}








@end
