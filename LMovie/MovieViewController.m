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
@synthesize connard = _connard;
@synthesize detailPanel = _connard2;
@synthesize panelUsed = _panelUsed;
@synthesize tableView = _tableView;
@synthesize movieManager = _movieManager;
@synthesize fetchedResultsController = _fetchedResultsController;



- (void)viewDidLoad
{
    [super viewDidLoad];
    _movieManager = [[MovieManager alloc] init];
    [[self.navigationController navigationBar] setBarStyle:UIBarStyleBlack];
    [[self.navigationController toolbar] setBarStyle:UIBarStyleBlackOpaque ];
    _panelUsed = NO;
        
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [_connard2 setFrame:CGRectMake(0, 0, 0, 0)];
    [_connard2 setHidden:YES];
    self.title = @"LMovie";
    _movieManager.fetchedResultsController = self.fetchedResultsController;


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
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    
    
    NSLog(@"Fetch ok");
    return _fetchedResultsController;
}










- (IBAction)fuck:(id)sender {
    
    [self.tableView reloadData];
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
    if([segue.identifier isEqualToString:@"segue to MovieEditorTVC to create movie"]){
        NSLog(@"segue to MovieEditorTVC to create movie");
        MovieEditorTVC *view = [[segue.destinationViewController viewControllers] lastObject];
        [view setContentSizeForViewInPopover:CGSizeMake(500, 630)];
        UIPopoverController *pc = [(UIStoryboardPopoverSegue *)segue popoverController];
        [pc setPopoverContentSize:CGSizeMake(500, 630)];
        view.delegate = self;
        view.popover = pc;
        view.movieManager = self.movieManager;
        if([sender isKindOfClass:[Movie class]]){
            view.movieToEdit = sender;
        }
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
    else if(action == ActionSave){


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
        //add code here for when you hit delete
    }    
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"cell for row");
    NSString *identifier = @"movie cell";
    MovieCellHorizontal *cell = [tableView dequeueReusableCellWithIdentifier:identifier];    
    
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
    NSLog(@"configuration cell après modification");
    
}


//HANDLIG SELECTION
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"segue to MovieEditorTVC to create movie" sender:[_fetchedResultsController objectAtIndexPath:indexPath]];
}












@end
