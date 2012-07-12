//
//  MovieEditorTVC.m
//  LMovie
//
//  Created by Jonathan Duss on 10.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovieEditorTVC.h"

@interface MovieEditorTVC ()
@property (nonatomic, weak) UIPopoverController *popover;
@property BOOL isReseting;
@property (nonatomic, strong) NSDictionary *valueEntered;
@end

@implementation MovieEditorTVC
@synthesize movieToEdit = _movieToEdit;
@synthesize movieManager = _movieManager;
@synthesize delegate = _delegate;
@synthesize popover = _popover; 
@synthesize isReseting = _isReseting;
@synthesize valueEntered = _valueEntered;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Add a movie";
    self.isReseting = NO;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    NSString *file = [[NSBundle mainBundle] pathForResource:@"keyOrder" ofType:@"plist"];        
    NSArray *sectionArray = [[NSArray arrayWithContentsOfFile:file] objectAtIndex:section];
    return [sectionArray count];
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"section: %d, row: %d ", indexPath.section, indexPath.row);
    
    int row = indexPath.row;
    NSString *identifier = @"";
    
    if(indexPath.section == 0 && row == 0){
            identifier = @"picture cell";
            MovieEditorPictureCell * cell = (MovieEditorPictureCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            return cell;
    }
    else {
        NSString *file = [[NSBundle mainBundle] pathForResource:@"keyOrder" ofType:@"plist"];        
        NSArray *sectionArray = [[NSArray arrayWithContentsOfFile:file] objectAtIndex:indexPath.section];
        NSDictionary *keyDico = [NSDictionary dictionaryWithDictionary:[sectionArray objectAtIndex:row]];
        NSString *key = [[keyDico allKeys] objectAtIndex:0];
        
        NSDictionary *dicoWithInfo = [keyDico valueForKey:key];
        
        
        identifier = @"general cell movieEditor";
        MovieEditorGeneralCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        //NSLog(@"Array %@", sectionArray);
        //NSLog(@"Populating cell: key %@, value: %@", key, value);
        cell.textField.text = [_valueEntered valueForKey:key];
        cell.infoLabel.text = [dicoWithInfo valueForKey:@"infoLabel"];
        [cell setAssociatedKey:key];
        cell.textField.placeholder = [dicoWithInfo valueForKey:@"placeHolder"];
        cell.textField.delegate = self;
        
        return cell;
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 && indexPath.row == 0){
        return 421;
    }
    else {
        return 45;
    }
}



-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"General informations";
    }
    else if (section == 1) {
        return @"Personal informations";
    }
    else {
        return @"ERROR";
    }
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

- (IBAction)resetButtonPressed:(UIBarButtonItem *)sender {
    //[_delegate actionExecuted:ActionReset];
    _isReseting = YES;
    [self.tableView reloadData];
    _isReseting = NO;
}

- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender {
    
    BOOL error1 = NO;
    
    NSString *test1 = [_valueEntered valueForKey:@"title"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[^a-zA-Z0-9]"];

    error1 = [test1 isEqualToString:@""] || test1 == nil || [predicate evaluateWithObject:test1]; 
    
    if(error1){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Erreur" 
                                                       message:@"Title cannot be empty" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    NSString *test2 = [_valueEntered valueForKey:@"year"];
    NSNumberFormatter *formatter;
    BOOL error2 = [formatter numberFromString:test2] == nil;
    if (error2) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Erreur" 
                                                       message:@"Year must be a number" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }

    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    MovieEditorGeneralCell *cell = (MovieEditorGeneralCell *) [[textField superview] superview];
    [_valueEntered setValue:textField.text forKey:cell.associatedKey];
}

@end
