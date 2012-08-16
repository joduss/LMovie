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
@property (nonatomic, strong) MovieManager* movieManager;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation MovieViewController
@synthesize tableView = _tableView;
@synthesize bouton = _bouton;
@synthesize movieManager = _movieManager;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize movieEditor = _movieEditor;



- (void)viewDidLoad
{
    [super viewDidLoad];
    _movieManager = [[MovieManager alloc] init];
    [[self.navigationController navigationBar] setBarStyle:UIBarStyleBlack];
    [[self.navigationController toolbar] setBarStyle:UIBarStyleBlackOpaque ];
        
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.title = @"LMovie";
    _movieManager.fetchedResultsController = self.fetchedResultsController;


	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setBouton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}



- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Movie" inManagedObjectContext:_movieManager.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:_movieManager.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsController = aFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    
    NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    DLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    
    
    DLog(@"Fetch ok");
    return _fetchedResultsController;
}






- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"segue to MovieEditorTVC to create movie"]){

        DLog(@"segue to MovieEditorTVC to create movie");
        MovieEditorTVC *view = [[segue.destinationViewController viewControllers] lastObject];
        //[view setContentSizeForViewInPopover:CGSizeMake(500, 630)];
        UIPopoverController *pc = [(UIStoryboardPopoverSegue *)segue popoverController];
        //[pc setPopoverContentSize:CGSizeMake(500, 630)];
        view.delegate = self;
        view.popover = pc;
        view.movieManager = self.movieManager;
        if([sender isKindOfClass:[Movie class]]){
            view.movieToEdit = sender;
        }
        _movieEditor = view;
    }
    else if ([segue.identifier isEqualToString:@"segue to movieInfoTVC"]) {
        [(SeguePopoverMovieInfoTVC *)segue setRec:[_tableView rectForRowAtIndexPath:[_tableView indexPathForSelectedRow]]];
        
        
        [[[[segue destinationViewController] childViewControllers] lastObject]setMovieManager:_movieManager];
        [[[[segue destinationViewController] childViewControllers] lastObject] setMovie:[_fetchedResultsController objectAtIndexPath:[_tableView indexPathForSelectedRow]]];
    }
    else if ([segue.identifier isEqualToString:@"segue to SettingTVC"]) {
        UINavigationController *nav = segue.destinationViewController;
        [[nav.childViewControllers lastObject] setMovieManager:self.movieManager];
    }
    else if ([segue.identifier isEqualToString:@"segue to searchTVC"]) {
        UINavigationController *nav = segue.destinationViewController;
        [[nav.childViewControllers lastObject] setMovieManager:self.movieManager];
    }


        
}

- (IBAction)addAMovieButtonPressed:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"segue to MovieEditorTVC to create movie" sender:sender];
}




/*******
 Delegate Methode de MovieEditorDelegate
 *******/
#pragma mark - MovieEditorDelegate method
- (void)actionExecuted:(ActionDone)action
{
    if(action == ActionReset){
    }
    else if(action == ActionSaveModification){
        NSIndexPath *path = [_tableView indexPathForSelectedRow];
        MovieCellHorizontal *cell = (MovieCellHorizontal *)[_tableView cellForRowAtIndexPath:path];
        cell.backgroundColor = [UIColor lightGrayColor];
        [_tableView deselectRowAtIndexPath:path animated:NO];
    }
}






/**************
 GESTION TABLEVIEW
 **************/

#pragma mark - gestion tableview

- (int)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    

    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_movieManager deleteMovie:[_fetchedResultsController objectAtIndexPath:indexPath]];
    }    
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"movie cell";
    MovieCellHorizontal *cell = [tableView dequeueReusableCellWithIdentifier:identifier]; 
    
    DLog(@"Cell for row MovieVC -> Cell: %@",cell);
    
    Movie *movie = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [cell configureCellWithMovie:movie];
    
    
    return cell;
}


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

/*
 // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
 {
 // In the simplest, most efficient, case, reload the table view.
 [self.tableView reloadData];
 }
 */

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Movie *movie = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [(MovieCellHorizontal *)cell configureCellWithMovie:movie];
    DLog(@"configuration cell après modification");
    
}


//HANDLIG SELECTION
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"segue to movieInfoTVC" sender:_tableView];
}










    


@end
