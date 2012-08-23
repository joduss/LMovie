//
//  MovieEditorTVC.m
//  LMovie
//
//  Created by Jonathan Duss on 10.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovieEditorTVC.h"
#import "MovieEditorViewedCell.h"


@interface MovieEditorTVC ()
@property (nonatomic, strong) UIPopoverController *pc;
@end


@implementation MovieEditorTVC
@synthesize movieToEdit = _movieToEdit;
@synthesize movieManager = _movieManager;
@synthesize delegate = _delegate;
@synthesize popover = _popover; 
@synthesize valueEntered = _valueEntered;
@synthesize pc = _pc;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Add a movie";
    _valueEntered = [[NSMutableDictionary alloc] init];
    [self.tableView setAllowsSelection:NO];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(_movieToEdit != nil){
        self.title = @"Modify informations";
        for(NSString *key in _movieManager.allKey){
            if([key isEqualToString:@"big_picture"]){
                [_valueEntered setValue:[UIImage imageWithData:_movieToEdit.big_picture] forKey:key];
            }
            else if([key isEqualToString:@"mini_picture"]){
                [_valueEntered setValue:[UIImage imageWithData:_movieToEdit.mini_picture] forKey:key];
            }
            else {
                [_valueEntered setValue:[[_movieToEdit valueForKey:key] description] forKey:key];
            }
        }
    }
    self.modalInPopover = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.modalInPopover = YES;
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
    return [[[_movieManager keyOrderedBySection] objectAtIndex:section] count];
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"section: %d, row: %d ", indexPath.section, indexPath.row);
    
    int row = indexPath.row;
    NSString *identifier = @""; //rempli plus tard
    
    if(indexPath.section == 0 && row == 0){
        identifier = @"picture cell";
        MovieEditorPictureCell * cell = (MovieEditorPictureCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if([_valueEntered valueForKey:@"big_picture"] == nil){
            NSString *file = [[NSBundle mainBundle] pathForResource:@"emptyartwork_big" ofType:@"jpg"];
            cell.cellImage = [UIImage imageWithContentsOfFile:file];
            [cell.selectButton addTarget:self action:@selector(pickImage:) forControlEvents:UIControlEventTouchUpInside];
        }
        else {
            DLog(@"Image mise");
            cell.cellImage = [_valueEntered valueForKey:@"big_picture"];
        }
        [cell.selectButton addTarget:self action:@selector(pickImage:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else {
        /*NSString *file = [[NSBundle mainBundle] pathForResource:@"Keys" ofType:@"plist"];
        NSArray *sectionArray = [[[NSArray arrayWithContentsOfFile:file] valueForKey:@"section"] objectAtIndex:indexPath.section];
        NSDictionary *keyDico = [NSDictionary dictionaryWithDictionary:[sectionArray objectAtIndex:row]];
        NSString *key = [[keyDico allKeys] objectAtIndex:0];
        
        //NSDictionary *dicoWithInfo = [keyDico valueForKey:key];
        */
        
        
        NSString *key = [_movieManager keyAtIndexPath:indexPath];


        UITableViewCell *cellToReturn;
        
        identifier = @"general cell movieEditor";
        
        //Pour cellule VIEWED
        if([key isEqualToString:@"viewed"]){
            
            identifier = @"viewed cell movieEditor";
            MovieEditorViewedCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            [cell.infoLabel setText:[_movieManager labelForKey:key]];
            [cell.choice addTarget:self action:@selector(segmentControlChanged:) forControlEvents:UIControlEventValueChanged];
            int viewedValue = [[_valueEntered valueForKey:@"viewed"] intValue];
            if(viewedValue < 0 || viewedValue > 2 || ![_valueEntered valueForKey:@"viewed"]){
                viewedValue = ViewedMAYBE;
                [_valueEntered setValue:[NSString stringWithFormat:@"%d", viewedValue] forKey:@"viewed"];
            }
            cell.choice.selectedSegmentIndex = viewedValue;
            
            cellToReturn = cell;
            
            
            
        }
        //pour user_rate et tmdb_rate
        else if ([key isEqualToString:@"user_rate"]){
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
            [cell configureCellWithRate:[[_valueEntered valueForKey:key] intValue]];
            
            
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
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 && indexPath.row == 0){
        return 360;
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







#pragma mark - Table view delegate


/****************************************
 IBACTION
 ****************************************/

#pragma mark - IBAction methods
- (IBAction)resetButtonPressed:(UIBarButtonItem *)sender {
    //[_delegate actionExecuted:ActionReset];
    _valueEntered = [[NSMutableDictionary alloc] init];
    
    [self.popover dismissPopoverAnimated:YES];
    [self dismissModalViewControllerAnimated:YES];
}



- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender {
    
    
    DLog(@"value entered lorsque save est pressé: %@", _valueEntered);

    
    BOOL error1 = NO;
    BOOL error2 = NO;
    
    [self.view endEditing:YES];
    
    //test: title est différente de rien
    NSString *test1 = [_valueEntered valueForKey:@"title"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[^a-zA-Z0-9]"];
    error1 = [test1 isEqualToString:@""] || test1 == nil || [predicate evaluateWithObject:test1]; 
    
    if(error1){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Erreur" 
                                                       message:@"Title cannot be empty" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        
        //Test de la condition: année est un nombre
        NSString *test2 = [_valueEntered valueForKey:@"year"];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        error2 = ([formatter numberFromString:test2] == nil);
        //DLog(@"From %@ -> formater -> %@", test2, [formatter numberFromString:test2]);
        if (error2) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Erreur" 
                                                           message:@"Year must be a number" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    
    if(error1 != YES && error2 != YES){
        DLog(@"SavebuttonPressed: no error up here");
        
        Movie *movie;
        
        //si le film à éditer existe, on modifie l'objet, sinon, crée un nouveau objet
        if(_movieToEdit == nil){
            [_movieManager insertMovieWithInformations:_valueEntered];
        }
        else {
            movie = [_movieManager modifyMovie:_movieToEdit WithInformations:_valueEntered];
            
            if([_delegate respondsToSelector:@selector(actionExecuted:)]){
                [_delegate actionExecuted:ActionSaveModification];
            }
        }
        
        if ([_delegate respondsToSelector:@selector(actualizeWithMovie:)]) {
            [self.delegate actualizeWithMovie:movie];
            DLog(@"actualiser");
            
        }
        
        [self.popover dismissPopoverAnimated:YES];
        [self dismissModalViewControllerAnimated:YES];
    }
    
    
}




/****************************************
 Textfield Delegate Methodes
 ****************************************/
#pragma mark - textfield delegate methods
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    MovieEditorGeneralCell *cell = (MovieEditorGeneralCell *) [[textField superview] superview];
    if(cell != nil && cell.associatedKey != nil){
        [_valueEntered setValue:textField.text forKey:cell.associatedKey];
        DLog(@"Value Entered set for: key: %@ and value: %@", cell.associatedKey, textField.text);
    }
}









/****************************************
 Image picker
 ****************************************/

#pragma mark - image picker

- (IBAction)pickImage:(id)sender{
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    [mediaUI setDelegate:self];
    [mediaUI setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [mediaUI setAllowsEditing:NO];
    
#warning Voir pour ajouter un bouton annuler

    
    
    //mediaUI.navigationItem.leftBarButtonItem = backButton;
    //mediaUI.navigationController.navigationItem.leftBarButtonItem = backButton;
    
    
    UIPopoverController *pc = [[UIPopoverController alloc] initWithContentViewController:mediaUI];
    CGRect fr = [sender frame];
    fr.origin.y = fr.origin.y + 50;
    [pc presentPopoverFromRect:fr inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    
    //_picker = mediaUI;
    _pc = pc;
    //[picker toolbar]
}

- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    UIImage *originalImage;//, *editedImage, *imageToUse;
    
    

        
    // Handle a still image picked from a photo album
    //if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)
        //== kCFCompareEqualTo) {
        /*
        editedImage = (UIImage *) [info objectForKey:
                                   UIImagePickerControllerEditedImage];*/
        originalImage = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];
        /*
        if (editedImage) {
            imageToUse = editedImage;
        } else {
            imageToUse = originalImage;
        }*/
        // Do something with imageToUse
    //}
    [_valueEntered setValue:originalImage forKey:@"big_picture"];
    [_valueEntered setValue:originalImage forKey:@"mini_picture"];
    [self.tableView reloadData];
    
    
    
    [self.pc dismissPopoverAnimated:YES];
    picker = nil;
}




#pragma mark - methode pour SegmentedControl
- (IBAction)segmentControlChanged:(UISegmentedControl *)sender;
{
    DLog(@"segmentControlChanged !!!");
    int value = [sender selectedSegmentIndex];
    DLog(@"value entered: %@", [NSNumber numberWithInt:value]);
    [_valueEntered setValue:[NSString stringWithFormat:@"%d", value] forKey:@"viewed"];
}



#pragma mark - RateViewCellDelegate méthode

-(void)rateChangeForKey:(NSString *)key newRate:(float)rate{
    DLog(@"rateChageForKey: %@, newRate:%f", key, rate);
    [_valueEntered setValue:[NSString stringWithFormat:@"%f", rate] forKey:key];
}




#pragma mark - Methode pour fermer picker
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissModalViewControllerAnimated:YES];
}


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    //viewController.title = @"connard";
    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelPicker:)];
}




-(IBAction)cancelPicker:(id)sender{
    [_pc dismissPopoverAnimated:YES];
}





@end
