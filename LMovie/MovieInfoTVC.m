//
//  MovieIntoTVC.m
//  LMovie
//
//  Created by Jonathan Duss on 15.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovieInfoTVC.h"

@interface MovieInfoTVC ()
@property (nonatomic, strong) NSMutableArray *keyArray;
@property (nonatomic, strong) NSDictionary *infos;
@end

@implementation MovieInfoTVC
@synthesize deleteButton = _deleteButton;
@synthesize modifyButton = _modifyButton;
@synthesize movieManager = _movieManager;
@synthesize movie = _movie;
@synthesize popover = _popover;



-(void)viewDidLoad
{
    NSLog(@"load");
    self.deleteButton.title = NSLocalizedString(@"Delete KEY", @"");
    self.modifyButton.title = NSLocalizedString(@"Modify KEY", @"");
}

-(void)viewDidUnload
{
    NSLog(@"unload");
    [self setModifyButton:nil];
    [self setDeleteButton:nil];
    [super viewDidUnload];
    self.popover = nil;
    self.movie = nil;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO ];
    [self.tableView setAllowsSelection:NO];
    [self prepareData];
    [self.tableView reloadData];
    self.popover.delegate = self;
    
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    DLog(@"popoverControllerDidDismiss dans movieinfo");
    self.popover = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}



/****************************************
 PREPARE DATA - preparation des données
 ****************************************/
#pragma mark - Preparation des données

//Méthode appelée une fois toutes les infos settées. Elle formatte les infos pour leur utilisation. On affiche que les données non nulles. Ainsi, on n'a pas de champs vide.
-(void)prepareData
{
    _infos = [[_movie formattedInfoInDictionnaryWithImage:ImageSizeBig] mutableCopy];
    
    _keyArray = [[NSMutableArray alloc] initWithObjects:
                 [[NSMutableArray alloc] init],
                 [[NSMutableArray alloc] init], nil];
    
    //On regarde si la valeur associée à la clé n'est pas nulle. Si elle n'est pas nulle, on l'ajoute dans le tableau de clé
    for(NSString *key in [_movieManager orderedKey]){
        if([_infos valueForKey:key] != nil || [key isEqualToString:@"big_picture"]){
            int section = [_movieManager sectionForKey:key];
            [[_keyArray objectAtIndex:section]addObject:key];
        }
    }
    
    
    DLog(@"infos du film: %@", [_infos description]);
    DLog(@"keyArray: %@", [_keyArray description]);
    
}






/****************************************
 TABLEVIEW
 ****************************************/
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
    return n;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"";

    UITableViewCell *cell;
    NSString *key = [[_keyArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    DLog(@"KEYS MOVIEINFO: %@", [key description]);
    
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
        
        [(MovieEditorPictureCell *)cell setCellImage:image];
    }
    else {
        if ([key isEqualToString:@"user_rate"] || [key isEqualToString:@"tmdb_rate"]){
            CellIdentifier = @"rateView cell";
            RateViewCell *thisCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            thisCell.infoLabel.text = [_movieManager labelForKey:key];
            //DLog(@"rateViewCell: %@ et rateView:%@", cell, cell.rateView);
            
            thisCell.key =  key;
            [thisCell configureCellWithRate:[[_infos valueForKey:key] floatValue]];
            thisCell.rateView.editable = NO;
            cell = thisCell;
            
        }
        else if([key isEqualToString:@"viewed"])
        {
            CellIdentifier = @"info cell viewed";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            UILabel *label = (UILabel *)[cell viewWithTag:200];
            UIImageView *image = (UIImageView *)[cell viewWithTag:201];
            label.text = [_movieManager labelForKey:key];
            
            NSString *file;
            switch ([[_infos valueForKey:key] intValue]) {
                case 0:
                    file = [[NSBundle mainBundle] pathForResource:@"PasVu" ofType:@"png"];
                    break;
                case 1:
                    file = [[NSBundle mainBundle] pathForResource:@"Vu" ofType:@"png"];
                    break;
                default:
                    file = [[NSBundle mainBundle] pathForResource:@"VuNoIdea" ofType:@"png"];
                    break;
            }
            [image setImage:[UIImage imageWithContentsOfFile:file]];
        }
        else
        {
            CellIdentifier = @"info cell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            UILabel *rightLabel = (UILabel *)[cell viewWithTag:101];
            UILabel *leftLabel = (UILabel *)[cell viewWithTag:100];
            NSString *rightLabelText = [_movieManager labelForKey:key];
            
            //DLog(@"key: %@", [_keyArray description]);
            if([key isEqualToString:@"resolution"])
            {
                NSString *title = [MovieManager resolutionToStringForResolution:[[_infos valueForKey:key] intValue]];
                rightLabel.text = title;
            }
            else if([key isEqualToAnyString:@"director", @"actors", @"language", @"subtitle", nil])
            {
                rightLabel.numberOfLines = 0;
                NSString *text = [_infos valueForKey:key];
                text = [text stringByReplacingOccurrencesOfString:@", " withString:@"\n"];
                CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:17]];
                rightLabel.text = text;

                
                CGRect rec = rightLabel.frame;
                int height = size.height;
                int numberOccurence = [[text componentsSeparatedByString:@"\n"] count];
                
                if(height < 45 && numberOccurence < 2){
                    height = 45;
                }
                CGRect new = CGRectMake(rec.origin.x, rec.origin.y, rec.size.width, height);
                rightLabel.frame = new;
            }
            else
            {
                DLog(@"KEYS MOVIEINFO: %@", [key description]);
                rightLabel.text = [_infos valueForKey:key];
            }
            
            leftLabel.text = rightLabelText;
        }
        
        
    }
    
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0 && indexPath.section == 0){
        return 330;
    }
    
    else {
        NSString *key = [[_keyArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        if([key isEqualToAnyString:@"director", @"actors", @"language", @"subtitle", nil] )
        {
            NSString *text = [_infos valueForKey:key];
            text = [text stringByReplacingOccurrencesOfString:@", " withString:@"\n"];
            CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(338, 1000) lineBreakMode:UILineBreakModeWordWrap];

            DLog(@"SIZE (heigh): %f", size.height);
            DLog(@"text: %@",text);
            
            int height = size.height;
            int numberOccurence = [[text componentsSeparatedByString:@"\n"] count];
            
            if(height < 45 && numberOccurence < 2){
                height = 45;
            }
            else
            {
                height = size.height + 20;
            }
            return height;
        }
        else
        {
            
            return 45;
        }
    }
}
    




/****************************************
 PREPARE_FOR_SEGUE
 ****************************************/
#pragma mark - prepareforSegue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MovieEditorTVC *view = [segue destinationViewController];
    view.movieManager = _movieManager;
    view.movieToEdit = _movie;
    view.delegate = self;
}


/****************************************
 MOVIE_EDITOR - Delegate
 ****************************************/
#pragma mark - MovieEditor delegate
- (void)actualizeWithMovie:(Movie *)movie
{
    DLog(@"Mise à jour des info");
    _movie = movie;
    [self prepareData];
    [self.tableView reloadData];
}



/****************************************
 IBACTION
 ****************************************/
#pragma mark - IBAction support
- (IBAction)deleteButtonPressed:(UIBarButtonItem *)sender;
{
    [_movieManager deleteMovie:_movie];
    [self.popover dismissPopoverAnimated:YES];
}















@end
