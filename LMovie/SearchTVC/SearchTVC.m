//
//  SearchTVC.m
//  LMovie
//
//  Created by Jonathan Duss on 15.08.12.
//
//

#import "SearchTVC.h"

@interface SearchTVC ()
@property (nonatomic, strong) UIPopoverController *pc2;

@end

@implementation SearchTVC
@synthesize searchButton = _searchButton;
@synthesize resetButton = _resetButton;

@synthesize delegate = _delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchButton.title = NSLocalizedString(@"Search KEY", @"");
    self.resetButton.title = NSLocalizedString(@"Reset KEY", @"");

}

- (void)viewDidUnload
{
    [self setSearchButton:nil];
    [self setResetButton:nil];
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
    int number = [[[MovieManagerUtils keyOrderedBySection] objectAtIndex:section] count];
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
    
    
    NSString *key = [MovieManagerUtils keyAtIndexPath:indexPathCorrected];
    
    
    
    identifier = @"general cell movieEditor";
    
    //Pour cellule VIEWED
    if([key isEqualToString:@"viewed"]){
        
        identifier = @"viewed cell movieEditor";
        MovieEditorViewedCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        //gère les segments
        [cell.choice removeAllSegments];
        [cell.choice insertSegmentWithTitle:NSLocalizedString(@"No KEY", @"") atIndex:ViewedNO animated:NO];
        [cell.choice insertSegmentWithTitle:NSLocalizedString(@"Yes KEY", @"") atIndex:ViewedYES animated:NO];
        [cell.choice insertSegmentWithTitle:NSLocalizedString(@"? KEY", @"") atIndex:ViewedMAYBE animated:NO];
        [cell.choice insertSegmentWithTitle:NSLocalizedString(@"All Viewed KEY", @"") atIndex:ViewedAll animated:NO];
        
        [cell.infoLabel setText:[MovieManagerUtils labelForKey:key]];
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
        
        cell.infoLabel.text = [MovieManagerUtils labelForKey:key];
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
        cell.infoLabel.text = [MovieManagerUtils labelForKey:key];
        cell.textField.placeholder = [MovieManagerUtils placeholderForKey:key];
        [cell setAssociatedKey:key];
        cell.textField.delegate = self;
        NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@" argumentArray:[NSArray arrayWithObjects:@"duration", @"year", @"rate", nil]];
        if([test evaluateWithObject:key]){
            [cell.textField setKeyboardType:UIKeyboardTypeNumberPad]; //si on entre une année, une durée ou une note -> clavier numérique
        }
        if([key isEqualToString:@"resolution"])
        {
            LMResolution reso = [[self.valueEntered valueForKey:key] intValue];
            if([self.valueEntered valueForKey:key] == nil){
                reso = LMResolutionAll;
            }
            NSString *title = [MovieManagerUtils resolutionToStringForResolution:reso];
            cell.textField.text = title;
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


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if( [textField.superview.superview isMemberOfClass:[MovieEditorGeneralCell class]])
    {
        MovieEditorGeneralCell *cell = (MovieEditorGeneralCell*) textField.superview.superview;
        CGRect rec = textField.superview.frame;
        rec = [self.parentViewController.view convertRect:rec fromView:textField.superview.superview];
        if([cell.associatedKey isEqualToString:@"resolution"]){
            //UIPickerView *picker = [[UIPickerView alloc] init];
            [textField resignFirstResponder];
            //[popover presentPopoverFromRect:textField.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            
            UINavigationController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Resolution Navigation Controller"];
            //UINavigationController *vcToPresent = [storyboard instantiateViewControllerWithIdentifier:@"Resolution Navigation Controller"];
            UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:vc];
            DLog(@"FRAME: o.x:%f, o.y:%f, h:%f, w:%f", rec.origin.x, rec.origin.y, rec.size.height, rec.size.width);
            [popover presentPopoverFromRect:rec inView:self.parentViewController.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
            _pc2 = popover;
            [vc.navigationController setHidesBottomBarWhenPushed:YES];
            
            ResolutionPickerVC *resolutionPicker = (ResolutionPickerVC *)[vc.childViewControllers lastObject];
            resolutionPicker.delegate = self;
            resolutionPicker.popover = popover;
            [resolutionPicker setForSearch:YES];
            
            // either one of the two, depending on if your view controller is the initial one
            
            
        }
    }
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



/****************************************
 ResolutionPicker - Delegate
 ****************************************/

#pragma mark - ResolutionPicker Delegate

-(void)selectedResolution:(LMResolution)resolution
{
    DLog(@"resolutionSelected");
    [self.valueEntered setObject:[NSString stringWithFormat:@"%d",resolution] forKey:@"resolution"];
    [self.tableView reloadData];
}



@end
