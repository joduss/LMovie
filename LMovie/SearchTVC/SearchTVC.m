//
//  SearchTVC.m
//  LMovie
//
//  Created by Jonathan Duss on 15.08.12.
//
//

#import "SearchTVC.h"

@interface SearchTVC ()

@end

@implementation SearchTVC

@synthesize delegate = _delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source


- (int)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int number = [[[_movieManager keyOrderedBySection] objectAtIndex:section] count];
    if(section == 0)
        number--;
    return number;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"section: %d, row: %d ", indexPath.section, indexPath.row);
    UITableViewCell *cellToReturn;
    
    
    //int row = indexPath.row;
    NSIndexPath *indexPathCorrected = indexPath;
    if(indexPath.section == 0){
        indexPathCorrected = [NSIndexPath indexPathForRow:(indexPath.row+1) inSection:indexPath.section];
    }
    NSString *identifier = @""; //rempli plus tard
    
    
    /*NSString *file = [[NSBundle mainBundle] pathForResource:@"Keys" ofType:@"plist"];
     NSArray *sectionArray = [[[NSArray arrayWithContentsOfFile:file] valueForKey:@"section"] objectAtIndex:indexPath.section];
     NSDictionary *keyDico = [NSDictionary dictionaryWithDictionary:[sectionArray objectAtIndex:row]];
     NSString *key = [[keyDico allKeys] objectAtIndex:0];
     
     //NSDictionary *dicoWithInfo = [keyDico valueForKey:key];
     */
    
    
    NSString *key = [_movieManager keyAtIndexPath:indexPathCorrected];
    
    
    
    identifier = @"general cell movieEditor";
    
    //Pour cellule VIEWED
    if([key isEqualToString:@"viewed"]){
        
        identifier = @"viewed cell movieEditor";
        MovieEditorViewedCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        [cell.infoLabel setText:[_movieManager labelForKey:key]];
        DLog(@"infolabel: %@", cell.infoLabel);
        [cell.choice addTarget:self action:@selector(segmentControlChanged:) forControlEvents:UIControlEventValueChanged];
        int viewedValue = [[self.valueEntered valueForKey:@"viewed"] intValue];
        if(viewedValue < 0 || viewedValue > 3 || ![self.valueEntered valueForKey:@"viewed"]){
            viewedValue = ViewedAll;
            [self.valueEntered setValue:[NSString stringWithFormat:@"%d", viewedValue] forKey:@"viewed"];
        }
        cell.choice.selectedSegmentIndex = viewedValue;
        
        cellToReturn = cell;
    
    }
    //pour user_rate et tmdb_rate
    else if ([key isEqualToString:@"user_rate"] || [key isEqualToString:@"tmdb_rate"]){
        identifier = @"rateView cell";
        RateViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        cell.infoLabel.text = [_movieManager labelForKey:key];
        cell.delegate = self;
        DLog(@"rateViewCell: %@ et rateView:%@", cell, cell.rateView);
        
        /*
         NSString *file = [[NSBundle mainBundle] pathForResource:@"keyOrder" ofType:@"plist"];
         NSArray *sectionArray = [[NSArray arrayWithContentsOfFile:file] objectAtIndex:indexPath.section];
         NSDictionary *keyDico = [NSDictionary dictionaryWithDictionary:[sectionArray objectAtIndex:row]];
         NSString *key = [[keyDico allKeys] objectAtIndex:0];*/
        cell.key =  key;
        [cell configureCellWithRate:[[self.valueEntered valueForKey:key] intValue]];
        
        
        cellToReturn = cell;
        
    }
    else {
        identifier = @"general cell movieEditor";
        MovieEditorGeneralCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        cell.textField.text = [self.valueEntered valueForKey:key];
        cell.infoLabel.text = [_movieManager labelForKey:key];
        cell.textField.placeholder = [_movieManager placeholderForKey:key];
        [cell setAssociatedKey:key];
        cell.textField.delegate = self;
        NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@" argumentArray:[NSArray arrayWithObjects:@"duration", @"year", @"rate", nil]];
        if([test evaluateWithObject:key]){
            [cell.textField setKeyboardType:UIKeyboardTypeNumberPad]; //si on entre une année, une durée ou une note -> clavier numérique
        }
        
        cellToReturn = cell;
    }
    
    //DLog(@"Array %@", sectionArray);
    //DLog(@"Populating cell: key %@, value: %@", key, value);
    
    
    //si clé contient "rate" faut agir différement
    
    
    DLog(@"Load key: %@, value: %@", key, [self.valueEntered valueForKey:key]);
    
    return cellToReturn;
    
    
}

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

- (IBAction)SearchButtonPressed:(UIBarButtonItem *)sender {
    DLog(@"search button pressé");
    [self.view endEditing:YES];
    DLog(@"info: %@", self.valueEntered);
    [self.delegate executeSearchWithInfo:self.valueEntered];
}

- (IBAction)resetButtonPressed:(UIBarButtonItem *)sender {
    self.valueEntered = nil;
    [self.tableView reloadData];
}





@end
