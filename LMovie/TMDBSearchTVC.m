//
//  TMDBSearchTVC.m
//  LMovie
//
//  Created by Jonathan Duss on 24.08.12.
//
//

#import "TMDBSearchTVC.h"

@interface TMDBSearchTVC ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (strong, nonatomic) NSMutableArray *arrayOfMovieID;
@end

@implementation TMDBSearchTVC
@synthesize cancelButton = _cancelButton;
@synthesize searchBar = _searchBar;



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Add movie KEY",@"");
    [self.cancelButton setTitle:NSLocalizedString(@"Cancel KEY", @"")];
    [self.searchBar setDelegate:self];
    _arrayOfMovieID = [[NSMutableArray alloc] init];
    _searchBar.placeholder = NSLocalizedString(@"Enter movie title for tmdb search KEY",@"");
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _popover.delegate = self;

}

- (void)viewDidUnload
{
    [self setSearchBar:nil];
    [self setCancelButton:nil];
    [super viewDidUnload];
    [self setPopover:nil];
    [self setSearchBar:nil];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


/****************************************
 POPOVER - Delegate
 ****************************************/
#pragma mark - Popover Delegate

//Permet de libérer la mémoire allouée VC.
-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.popover = nil;
}

-(BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)thePopoverController{
    DLog(@"Clic dehors");
    return NO;
}


- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender {
    [self.popover dismissPopoverAnimated:YES];
}



/****************************************
 TABLEVIEW
 ****************************************/
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_arrayOfMovieID count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cellToReturn;
    if( [_arrayOfMovieID count] == 1 && ([[_arrayOfMovieID objectAtIndex:0] isEqualToString:@"NO RESULT"] || [[_arrayOfMovieID objectAtIndex:0] isEqualToString:@"ERROR"] ))
    {
        DLog(@"Pas de résultat");
        static NSString *CellIdentifier = @"TMDBSearchTVC cell no result";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        UILabel *label = (UILabel *)[cell viewWithTag:88];
        if([[_arrayOfMovieID objectAtIndex:0] isEqualToString:@"NO RESULT"])
            label.text = NSLocalizedString(@"No movie with this title KEY",@"");
        else
            label.text = NSLocalizedString(@"Error while searching KEY",@"");
        
        cellToReturn = cell;
    }
    else
    {
        static NSString *CellIdentifier = @"TMDBSearchTVC cell";
        TMDBSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        [cell setInfosWithTMDBMovieID:[_arrayOfMovieID objectAtIndex:indexPath.row]];
        //DLog(@"arrayOfMovieID: %@",[_arrayOfMovieID description]);
        // Configure the cell.
        cellToReturn = cell;
    }
    
    return cellToReturn;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //The user selected a cell, representing a movie. Now we have to get the information and show the MovieEditor so he can
    //modify some information and add some personal information related to that movie
    DLog(@"selection019");
    TMDBMovie *movie = [ [TMDBMovie alloc] initWithMovieID:[_arrayOfMovieID objectAtIndex:indexPath.row]];
    __block NSDictionary *infoDico;
    
    MBProgressHUD *progressView = [[MBProgressHUD alloc] initWithView:self.view];
    [progressView setMode:MBProgressHUDModeIndeterminate];
    progressView.labelText = @"Loading Informations";
    [self.view addSubview:progressView];
    [progressView show:YES];
    [progressView setMinShowTime:1];
    
    
    //asynchronous download of the movie's data.
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [movie loadBasicInfoFromTMDB];
        infoDico = movie.infosDictionnaryFormatted;
        
        dispatch_async( dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self performSegueWithIdentifier:@"segue to MovieEditorTVC" sender:infoDico];
            DLog(@"On va ajouter un film avec ces infos: %@", [infoDico description]);
        });
    });
}





/****************************************
 SEARCH_BAR - Delegate
 ****************************************/
#pragma mark - SearchBar delegate

/** Send the user's queries*/
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_searchBar resignFirstResponder];
    DLog(@"Recherche en cours");
    [_arrayOfMovieID removeAllObjects];
    [self.tableView reloadData];
    
#warning Add the support for more results
    //int numberPages = 0;
    //int numberResults = 0;
    
    //execute la recherche:
    //NSMutableArray *json = [[NSMutableArray alloc] init];
    NSDictionary *dico;
    BOOL success = NO;
    int try = 0;
    
    //Load the results on TMDB as JSON dictionary object
    while(!success){
        @try {
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.themoviedb.org/3/search/movie?api_key=%@&query=%@", TMDB_API_KEY, [searchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
            
            //Accès au movie avec l'ID 27205 (inception)
            //DLog(@"URL: %@", [NSString stringWithFormat:@"http://api.themoviedb.org/3/movie/27205?api_key=e892ef686dde8dbc5972b3eda282c5a9", TMDB_API_KEY);
            
            dico = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            success = YES;
        }
        @catch (NSException *exception) {
            //If there is an exception, try again a few times
            try ++;
            DLog(@"castch");
            if(try > 3){
                DLog(@"break");
                break;
            }
        }
    }
    
    //Process the data that are in the dictionary
    if(success){
        DLog(@"ok, %lud",(unsigned long)[dico count]);
        NSArray *array = [dico valueForKey:@"results"];
        if([array count] <= 0){
            [_arrayOfMovieID addObject:@"NO RESULT"];
        }
        else{
            for(NSDictionary *movieInfo in array){
                [_arrayOfMovieID addObject:[[movieInfo valueForKey:@"id"] description]];
            }
        }
    }
    else{
        DLog(@"pas ok");
        [_arrayOfMovieID addObject:@"ERROR"];
    }
    [self.tableView reloadData];
}


/****************************************
 PREPARE_FOR_SEGUE
 ****************************************/
#pragma mark - prepareForSegue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"segue to MovieEditorTVC"])
    {
        MovieEditorTVC *vc = segue.destinationViewController;
        vc.addedFromTMDB = YES;
        vc.movieInformation = sender;
        vc.movieManager = _movieManager;
        vc.popover = self.popover;
    }
}




@end
