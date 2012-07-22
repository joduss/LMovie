//
//  MovieIntoTVC.m
//  LMovie
//
//  Created by Jonathan Duss on 15.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovieInfoTVC.h"

@interface MovieInfoTVC ()
@property (nonatomic, strong) NSMutableArray *infoArray;
@end

@implementation MovieInfoTVC
@synthesize infoArray = _infoArray;
@synthesize movieManager = _movieManager;
@synthesize movie = _movie;
@synthesize deleteButtonPressed = _deleteButtonPressed;
@synthesize popover = _popover;



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO ];
    [self.tableView setAllowsSelection:NO];
}
-(void)setMovie:(Movie *)movie
{
    _movie = movie;
    DLog(@"setMovie");
    [self setInfo:[_movie formattedInfoInDictionnary]];
}


-(void)setInfo:(NSDictionary *)info
{
    DLog(@"info: %@", [info description]);
    
    
    for(NSString * key in [_movieManager orderedKey
                           ]){
        
        DLog(@"coucou clé: %@", key);
        BOOL isFirst = YES;
        int section = [_movieManager sectionForKey:key];
        
        
        if([key isEqualToString:@"picture"]){
            UIImage *image = [info valueForKey:key];
            infoFormattedForArray *infoFormatted = [[infoFormattedForArray alloc] init];
            infoFormatted.isFirst = isFirst;
            infoFormatted.value = image;
            infoFormatted.key = key; 
            [[self.infoArray objectAtIndex:0] addObject:infoFormatted];
        }
        else {
            NSString *value = [info valueForKey:key];
            DLog(@"type: %@", value);
            NSArray *valueArray =[value componentsSeparatedByString:@", "];
            for(NSString *formattedValue in valueArray){
                infoFormattedForArray *infoFormatted = [[infoFormattedForArray alloc] init];
                infoFormatted.isFirst = isFirst;
                infoFormatted.value = formattedValue;
                infoFormatted.key = key;
                [[self.infoArray objectAtIndex:section] addObject:infoFormatted];
                isFirst = NO;
            }
        }
    }
    DLog(@"count après set info: %d", [_infoArray count]);
}


-(NSMutableArray *)infoArray
{
    if(_infoArray == nil){
        NSMutableArray *a1 = [[NSMutableArray alloc] init];
        NSMutableArray *a2 = [[NSMutableArray alloc] init];
        _infoArray = [[NSMutableArray alloc] initWithObjects:a1, a2, nil];
    }
    return _infoArray;
}


- (void)viewDidUnload
{
    [self setDeleteButtonPressed:nil];
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
    // Return the number of sections.
    DLog(@"count: %d", [_infoArray count]);
    return [_infoArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[_infoArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"";
    infoFormattedForArray *infoToUse = [[_infoArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(indexPath.row == 0 && indexPath .section == 0){
        CellIdentifier = @"picture cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        UIImage *image;
        if(infoToUse.value == nil){
            image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"emptyartwork_big" ofType:@"jpg"]];
        }
        else {
            image = infoToUse.value;
        }
        DLog(@"infoToUse key: %@", infoToUse.key);
        
        //[imageView re];
        [(MovieEditorPictureCell *)cell setCellImage:image];
    }
    else {
        CellIdentifier = @"info cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        UILabel *rightLabel = (UILabel *)[cell viewWithTag:101];
        UILabel *leftLabel = (UILabel *)[cell viewWithTag:100];
        NSString *rightLabelText = @"";
        
        if(infoToUse.isFirst){
            rightLabelText = [_movieManager labelForKey:infoToUse.key];
        }
        rightLabel.text = infoToUse.value;
        leftLabel.text = rightLabelText;
        
        
    }
    
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0 && indexPath.section == 0){
        return 330;
    }
    else if (((infoFormattedForArray *)[[_infoArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]).isFirst == false){
        return 35;
    }
    else {
        return 45;
    }
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




#pragma mark - Segue support

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MovieEditorTVC *view = [[[segue destinationViewController] childViewControllers] lastObject];
    view.movieManager = _movieManager;
    view.movieToEdit = _movie;
    view.delegate = self;
}

- (void)actualizeWithMovie:(Movie *)movie
{
    _infoArray = nil;
    [self setMovie:movie];
    [self.tableView reloadData];
}




- (IBAction)modifyButtonPressed:(UIBarButtonItem *)sender {
    /*UIStoryboard storyboard = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    MovieEditorTVC *me = [storyboard instantiateViewControllerWithIdentifier:@""]
    UIPopoverController *pop = [[UIPopoverController alloc] initWithContentViewController:me];
    me.popover = pop;
    me.movieToEdit = self.movie;
    me.movieManager = self.movieManager;
    [pop presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];*/
}




@end
