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
@property (nonatomic, strong) NSMutableArray *keyArray;
@property (nonatomic, strong) NSDictionary *infos;
@end

@implementation MovieInfoTVC
@synthesize infoArray = _infoArray;
@synthesize movieManager = _movieManager;
@synthesize movie = _movie;
@synthesize popover = _popover;



-(void)awakeFromNib
{
    DLog(@"APPO 1: taille: %f", self.view.bounds.size.width);

}

-(void)viewDidLoad{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO ];
    [self.tableView setAllowsSelection:NO];
    [self prepareData];
    [self.tableView reloadData];
}

-(void)prepareData
{
    _infos = [[_movie formattedInfoInDictionnaryWithImage:ImageSizeBig] mutableCopy];
        
    _keyArray = [[NSMutableArray alloc] initWithObjects:
                 [[NSMutableArray alloc] init],
                 [[NSMutableArray alloc] init], nil];
    
    for(NSString *key in [_movieManager orderedKey]){
        if([_infos valueForKey:key] != nil){
            int section = [_movieManager sectionForKey:key];
            [[_keyArray objectAtIndex:section]addObject:key];
        }
    }
    
    DLog(@"infos du film: %@", [_infos description]);
    DLog(@"keyArray: %@", [_keyArray description]);

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
    int section = 0;
    for(NSString *key in [_movieManager allKey]){
        if([_infos valueForKey:key] != nil){
            int thisSection = [_movieManager sectionForKey:key] + 1;
            if(thisSection > section){
                section = thisSection;
            }
        }
    }
    return section;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int n = [[_keyArray objectAtIndex:section] count];
    /*NSArray *AllKeys = [[_movieManager keyOrderedBySection] objectAtIndex:section];
    for(NSString *key in AllKeys){
        if([_infos valueForKey:key] != nil){
            n++;
            DLog(@"Pour la clé: %@  l'info: %@", key, [[_infos valueForKey:key] description]);
        }
    }*/
    
    
    // Return the number of rows in the section.
    //return [[_infoArray objectAtIndex:section] count];
    return n;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"";
    //infoFormattedForArray *infoToUse = [[_infoArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    UITableViewCell *cell;
    NSString *key = [[_keyArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if(indexPath.row == 0 && indexPath.section == 0){
        key = @"big_picture";
        CellIdentifier = @"picture cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        UIImage *image;
        if([_infos valueForKey:key] == nil){
            image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"emptyartwork_big" ofType:@"jpg"]];
        }
        else {
            image = [_infos valueForKey:key];
        }
        
        //[imageView re];
        [(MovieEditorPictureCell *)cell setCellImage:image];
    }
    else {
        if ([key isEqualToString:@"user_rate"] || [key isEqualToString:@"tmdb_rate"]){
            CellIdentifier = @"rateView cell";
            RateViewCell *thisCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            thisCell.infoLabel.text = [_movieManager labelForKey:key];
            //DLog(@"rateViewCell: %@ et rateView:%@", cell, cell.rateView);
            
            thisCell.key =  key;
            [thisCell configureCellWithRate:[[_infos valueForKey:key] intValue]];
            thisCell.rateView.editable = NO;
            cell = thisCell;
            
        }
        else
        {
        CellIdentifier = @"info cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        UILabel *rightLabel = (UILabel *)[cell viewWithTag:101];
        UILabel *leftLabel = (UILabel *)[cell viewWithTag:100];
        NSString *rightLabelText = [_movieManager labelForKey:key];
        
            DLog(@"key: %@", [_keyArray description]);
        rightLabel.text = [_infos valueForKey:key];
        leftLabel.text = rightLabelText;
        }
        
        
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
    /*else if (((infoFormattedForArray *)[[_infoArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]).isFirst == false){
        return 35;
    }*/
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



#pragma mark - MovieEditorDelegate methods
- (void)actualizeWithMovie:(Movie *)movie
{
    _infoArray = nil;
    [self setMovie:movie];
    [self.tableView reloadData];
}



#pragma mark - IBAction support
-(void)deleteButtonPressed:(UIBarButtonItem *)sender
{
    [_movieManager deleteMovie:_movie];
    [self.popover dismissPopoverAnimated:YES];
}















@end
