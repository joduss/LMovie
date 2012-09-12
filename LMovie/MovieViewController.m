//
//  MovieViewController.m
//  LMovie
//
//  Created by Jonathan Duss on 02.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovieViewController.h"
#import "MovieInfoTVC.h"

@interface MovieViewController ()
@property BOOL panelUsed;
@property (nonatomic, strong) MovieManager* movieManager;
@property (nonatomic, strong) NSDictionary *searchInfo;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@property (nonatomic, weak) UIPopoverController *openedPopover;
@property (nonatomic, weak) UIActionSheet *openedActionSheet;

@end



@implementation MovieViewController
@synthesize tableView = _tableView;
@synthesize bouton = _bouton;
@synthesize movieManager = _movieManager;
@synthesize fetchedResultsController = _fetchedResultsController;



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
    [[NSNotificationCenter defaultCenter] addObserver:self.tableView  selector:@selector(clearS) name:@"Popover over MovieViewController closed" object:nil];
}

- (void)viewDidUnload
{
    [self setBouton:nil];
    [super viewDidUnload];
    [self setOpenedPopover:nil];
    [self setOpenedActionSheet:nil];
    [self setSearchInfo:nil];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


/****************************************
 FETCH_RESULT_CONTROLLER - gestion
 ****************************************/
#pragma mark - FetchResultController
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


-(void)executeSearchWithInfo:(NSDictionary *)info
{
    _fetchedResultsController.delegate = nil;
    _fetchedResultsController = nil;
    //DLog(@"executeSearchWithInfo: %@", [info description]);
    if(info){

        //DLog(@"executeSearchWithInfo: %@", [info description]);
        _searchInfo = info;
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
        
        //FILTRAGE:
        NSPredicate *filterPredicate;
        NSMutableArray *predicateArray = [NSMutableArray array];
        if(info){
            
            for(NSString *key in [info allKeys]){
                
                if([key isEqualToString:@"user_rate"] || [key isEqualToString:@"tmdb_rate"] || [key isEqualToString:@"year"]){
                    [predicateArray addObject:[NSPredicate predicateWithFormat:@"%K >= %@",  key, [info valueForKey:key]]];
                }
                else if ([key isEqualToString:@"resolution"]){
                    //si la résolution "TOUT" est choisi, on l'ignore, ainsi on ne trie pas les résolutions
                    LMResolution resolution = (LMResolution)[[info valueForKey:key] intValue];
                    if(resolution != LMResolutionAll){
                        DLog(@"autre résolution: %d",resolution);
                        [predicateArray addObject:[NSPredicate predicateWithFormat:@"%K == %d",  key, resolution]];
                    }
                }
                else {
                    [predicateArray addObject:[NSPredicate predicateWithFormat:@"%K contains[cd] %@",  key, [info valueForKey:key]]];
                }
                //Choisi pour tout(vu, non vu, ?). Ainsi, en enlevant le predicate, on ne tient pas compte, et c'est recherche pour tout.
                if(([key isEqualToString:@"viewed"] && [[info valueForKey:@"viewed"] intValue] == 3) || [[info valueForKey:@"viewed"] isEqualToString:@""]){
                    DLog(@"last deleted");
                    [predicateArray removeLastObject];
                }
                
            }

            
            DLog(@"Tous les predicates: %@", [predicateArray description]);
            filterPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicateArray];

        }
        
        [fetchRequest setPredicate:filterPredicate];
        
        
        
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        [NSFetchedResultsController deleteCacheWithName:nil];
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:_movieManager.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        aFetchedResultsController.delegate = self;
        self.fetchedResultsController = aFetchedResultsController;
        
        
        NSError *error = nil;
        if (![self.fetchedResultsController performFetch:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            DLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    [self.tableView reloadData];
    //[self.tableView beginUpdates];

}



/****************************************
 IBACTIONS
 ****************************************/
#pragma mark - IBAction
- (IBAction)modif:(id)sender {
    self.tableView.editing = !self.tableView.editing;
}

- (IBAction)searchButtonPressed:(UIBarButtonItem *)sender {
    if(self.openedPopover == nil){
        DLog(@"searchButton Pressed: self.popover nil donc");
        [self performSegueWithIdentifier:@"segue to searchTVC" sender:sender];
    }
}

- (IBAction)addAMovieButtonPressed:(UIBarButtonItem *)sender {
    //[self performSegueWithIdentifier:@"segue to MovieEditorTVC to create movie" sender:sender];
    
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Choose way to add  new Movie KEY", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel KEY", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Manual KEY", @""), NSLocalizedString(@"Info from TMDB", @""), nil];
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    
    [popupQuery showFromBarButtonItem:sender animated:YES];
}




/****************************************
 PREPARE_FOR_SEGUE
 ****************************************/
#pragma mark - prepareForSegue
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
        [[nav.childViewControllers lastObject] setDelegate:self];
        [[nav.childViewControllers lastObject] setValueEntered:[_searchInfo mutableCopy]];
        _searchInfo = nil;
        self.openedPopover = [(UIStoryboardPopoverSegue *)segue popoverController];
        

    }
    else if ([segue.identifier isEqualToString:@"segue to TMDBSearchTVC"]){
        TMDBSearchTVC *view = [[segue.destinationViewController viewControllers] lastObject];
        view.popover = [(UIStoryboardPopoverSegue *)segue popoverController];
        view.movieManager = self.movieManager;
    }


        
}


/****************************************
 ACTION_SHEET Delegate
 ****************************************/
#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self performSegueWithIdentifier:@"segue to MovieEditorTVC to create movie" sender:self];
            break;
            
        case 1:
            [self performSegueWithIdentifier:@"segue to TMDBSearchTVC" sender:self];
            break;
        default:
            break;
    }
}




/****************************************
 MOVIE_EDITOR Delegate
 ****************************************/

#pragma mark - MovieEditor Delegate
- (void)actionExecuted:(ActionDone)action
{
    DLog(@"ACTION EXECUTED")
    if(action == ActionReset){
    }
    else if(action == ActionSaveModification){
        NSIndexPath *path = [_tableView indexPathForSelectedRow];
        MainCellHorizontal *cell = (MainCellHorizontal *)[_tableView cellForRowAtIndexPath:path];
        cell.backgroundColor = [UIColor lightGrayColor];
        [_tableView deselectRowAtIndexPath:path animated:NO];
    }
}






/****************************************
 TABLEVIEW
 ****************************************/

#pragma mark - TableView

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
    MainCellHorizontal *cell = [tableView dequeueReusableCellWithIdentifier:identifier]; 
    
    //DLog(@"Cell for row MovieVC -> Cell: %@",cell);
    
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



- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Movie *movie = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [(MainCellHorizontal *)cell configureCellWithMovie:movie];
    DLog(@"configuration cell après modification");
    
}


//Gère la selection
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"segue to movieInfoTVC" sender:_tableView];
}










    


@end
