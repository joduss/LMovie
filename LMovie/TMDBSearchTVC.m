//
//  TMDBSearchTVC.m
//  LMovie
//
//  Created by Jonathan Duss on 24.08.12.
//
//

#import "TMDBSearchTVC.h"

@interface TMDBSearchTVC ()
@property (strong, nonatomic) NSMutableArray *arrayOfMovieID;
@end

@implementation TMDBSearchTVC
@synthesize searchBar = _searchBar;



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Add Movie";
    [self.searchBar setDelegate:self];
    _arrayOfMovieID = [[NSMutableArray alloc] init];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setSearchBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

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
            label.text = @"No movie found with this title";
        else
            label.text = @"Oups, error while searching :(";
        
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
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    
    DLog(@"selection019");
    TMDBMovie *movie = [ [TMDBMovie alloc] initWithMovieID:[_arrayOfMovieID objectAtIndex:indexPath.row]];
    __block NSDictionary *infoDico;
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [movie loadBasicInfoFromTMDB];
        infoDico = movie.infosDictionnaryFormatted;
        
        dispatch_async( dispatch_get_main_queue(), ^{
            DLog(@"On va ajouter un film avec ces infos: %@", [infoDico description]);
        });
    });
    
    
    
    
    
    
}



#pragma mark - SearchBar delegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_searchBar resignFirstResponder];
    DLog(@"Recherche en cours");
    [_arrayOfMovieID removeAllObjects];
    [self.tableView reloadData];
    //execute la recherche:
    int numberPages = 0;
    int numberResults = 0;
    
    //execute la recherche:
    NSMutableArray *json = [[NSMutableArray alloc] init];
    NSDictionary *dico;
    BOOL success = NO;
    int try = 0;
    
    //chargement du dico des résultats
    while(!success){
        @try {
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.themoviedb.org/3/search/movie?api_key=%@&query=%@", TMDB_API_KEY, [searchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
            
            
            dico = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            success = YES;
        }
        @catch (NSException *exception) {
            try ++;
            DLog(@"castch");
            if(try > 3){
                DLog(@"break");
                break;
            }
        }
    }
    
    //On traire selon succes ou non, et  selon résultat ou non
    if(success){
        DLog(@"ok, %d", [dico count]);
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

@end
