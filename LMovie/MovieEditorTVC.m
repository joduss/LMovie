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

@property (nonatomic, strong) UIPopoverController *pc2;
@end


@implementation MovieEditorTVC
@synthesize saveButton = _saveButton;
@synthesize cancelButton = _cancelButton;
@synthesize movieToEdit = _movieToEdit;
@synthesize movieManager = _movieManager;
@synthesize delegate = _delegate;
@synthesize popover = _popover; 
@synthesize movieInformation = _movieInformation;
@synthesize pc = _pc;
@synthesize addedFromTMDB = _addedFromTMDB;




- (void)viewDidLoad
{
    [super viewDidLoad];
    if(!_movieInformation)
    {
        _movieInformation = [[NSMutableDictionary alloc] init];
    }
    [self.tableView setAllowsSelection:NO];
    [self.navigationItem setHidesBackButton:YES animated:YES];
    self.saveButton.title = NSLocalizedString(@"Save KEY", @"");
    self.cancelButton.title = NSLocalizedString(@"Cancel KEY", @"");


    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.popover.delegate = self;
    if(_movieToEdit != nil){
        self.title = NSLocalizedString(@"Modify movie KEY", @"");
        for(NSString *key in _movieManager.allKey){
            if([key isEqualToString:@"big_picture"]){
                [_movieInformation setValue:[UIImage imageWithData:_movieToEdit.big_picture] forKey:key];
            }
            else if([key isEqualToString:@"mini_picture"]){
                [_movieInformation setValue:[UIImage imageWithData:_movieToEdit.mini_picture] forKey:key];
            }
            else {
                [_movieInformation setValue:[[_movieToEdit valueForKey:key] description] forKey:key];
            }
        }
    }
    else
    {
        self.title = NSLocalizedString(@"Add movie KEY", @"");
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
    [self setSaveButton:nil];
    [self setCancelButton:nil];
    [super viewDidUnload];
    self.popover = nil;
    self.delegate = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.popover.delegate = nil;
    self.popover = nil;
}


-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}






/****************************************
 TABLEVIEW
 ****************************************/
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[_movieManager keyOrderedBySection] objectAtIndex:section] count];
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    
    NSInteger row = indexPath.row;
    NSString *identifier = @""; //rempli plus tard
    
    if(indexPath.section == 0 && row == 0){
        identifier = @"picture cell";
        MovieEditorPictureCell * cell = (MovieEditorPictureCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if([_movieInformation valueForKey:@"big_picture"] == nil){
            NSString *file = [[NSBundle mainBundle] pathForResource:@"emptyartwork_big" ofType:@"jpg"];
            cell.cellImage = [UIImage imageWithContentsOfFile:file];


        }
        else {
            DLog(@"Image mise");
            cell.cellImage = [_movieInformation valueForKey:@"big_picture"];
        }
        [cell.selectButton addTarget:self action:@selector(pickImage:) forControlEvents:UIControlEventTouchUpInside];
        [cell.deleteImageButton addTarget:self action:@selector(deleteImage) forControlEvents:UIControlEventTouchUpInside];
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
            
            //gère les segments
            [cell.choice removeAllSegments];
            [cell.choice insertSegmentWithTitle:NSLocalizedString(@"No KEY", @"") atIndex:ViewedNO animated:NO];
            [cell.choice insertSegmentWithTitle:NSLocalizedString(@"Yes KEY", @"") atIndex:ViewedYES animated:NO];
            [cell.choice insertSegmentWithTitle:NSLocalizedString(@"? KEY", @"") atIndex:ViewedMAYBE animated:NO];
            
            [cell.choice addTarget:self action:@selector(segmentControlChanged:) forControlEvents:UIControlEventValueChanged];
            int viewedValue = [[_movieInformation valueForKey:@"viewed"] intValue];
            if(viewedValue < 0 || viewedValue > 2 || ![_movieInformation valueForKey:@"viewed"]){
                viewedValue = ViewedMAYBE;
                [_movieInformation setValue:[NSString stringWithFormat:@"%d", viewedValue] forKey:@"viewed"];
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
            [cell configureCellWithRate:[[_movieInformation valueForKey:key] floatValue]];
            
            
            cellToReturn = cell;

        }
        else {
            identifier = @"general cell movieEditor";
            MovieEditorGeneralCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if([key isEqualToString:@"resolution"])
            {
                NSString *title = [MovieManager resolutionToStringForResolution:[[self.movieInformation valueForKey:key] intValue]];
                cell.textField.text = title;
            }
            else
            {
                cell.textField.text = [self.movieInformation valueForKey:key];
            }
            cell.infoLabel.text = [_movieManager labelForKey:key];
            cell.textField.placeholder = [_movieManager placeholderForKey:key];
            [cell setAssociatedKey:key];
            cell.textField.delegate = self;
            
            if([key isEqualToAnyString:@"duration", @"year",@"tmdb_rate", nil]){
                [cell.textField setKeyboardType:UIKeyboardTypeNumberPad]; //si on entre une année, une durée ou une note -> clavier numérique
            }
            else {
                [cell.textField setKeyboardType:UIKeyboardTypeAlphabet];
            }
            
            cellToReturn = cell;
        }

        //DLog(@"Array %@", sectionArray);
        //DLog(@"Populating cell: key %@, value: %@", key, value);

        
        //si clé contient "rate" faut agir différement
        
        
        DLog(@"Load key: %@, value: %@", key, [self.movieInformation valueForKey:key]);
        
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
        return NSLocalizedString(@"General info KEY", @"");
    }
    else if (section == 1) {
        return NSLocalizedString(@"Personal info KEY", @"");
    }
    else {
        return NSLocalizedString(@"ERROR KEY", @"");
    }
}






/****************************************
 IBACTION
 ****************************************/

#pragma mark - IBAction methods
/** Discard the movie creation or modification */
- (IBAction)resetButtonPressed:(UIBarButtonItem *)sender {
    //[_delegate actionExecuted:ActionReset];
    _movieInformation = [[NSMutableDictionary alloc] init];
    
    [self.popover dismissPopoverAnimated:YES];
    //[self dismissModalViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}


/** Save the movie information in the db */
- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender {
    
    [self.view endEditing:YES];

    
    DLog(@"value entered lorsque save est pressé: %@", [_movieInformation description]);

    
    BOOL error1 = NO;
    BOOL error2 = NO;
    
    
    //test: title est différente de rien
    NSString *test1 = [_movieInformation valueForKey:@"title"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[^a-zA-Z0-9]"];
    error1 = [test1 isEqualToString:@""] || test1 == nil || [predicate evaluateWithObject:test1]; 
    
    if(error1){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Error KEY", @"")  
                                                       message:NSLocalizedString(@"Title cannot be empty KEY", @"") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        
        //Test de la condition: année est un nombre
        NSString *test2 = [_movieInformation valueForKey:@"year"];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        error2 = ([formatter numberFromString:test2] == nil);
        //DLog(@"From %@ -> formater -> %@", test2, [formatter numberFromString:test2]);
        if (error2) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Error KEY", @"") 
                                                           message:NSLocalizedString(@"Year must be a number", @"") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    
    if(error1 != YES && error2 != YES){
        DLog(@"SavebuttonPressed: no error up here");
        
        Movie *movie;
        
        //si le film à éditer existe, on modifie l'objet, sinon, crée un nouveau objet
        //If we are adding a new movie in the library, then we create a new record in the db
        if(_movieToEdit == nil || _addedFromTMDB){
            [_movieManager insertMovieWithInformations:_movieInformation];
        }
        else {
            //Otherwise it means movie information are being modified, thus we only update the record
            movie = [_movieManager modifyMovie:_movieToEdit WithInformations:_movieInformation];
            
            if([_delegate respondsToSelector:@selector(actionExecuted:)]){
                [_delegate actionExecuted:ActionSaveModification];
            }
        }
        
        if ([_delegate respondsToSelector:@selector(actualizeWithMovie:)]) {
            [self.delegate actualizeWithMovie:movie];
            DLog(@"actualiser");
            
        }
        
        if(self.popover){
            [self.popover dismissPopoverAnimated:YES];
        }
        else{
            //[self dismissModalViewControllerAnimated:YES];
            [self.navigationController popViewControllerAnimated:YES];
        }
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
        [_movieInformation setValue:textField.text forKey:cell.associatedKey];
        [textField resignFirstResponder];
        DLog(@"Value Entered set for: key: %@ and value: %@", cell.associatedKey, textField.text);
    }
    DLog(@"coucou2");

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    DLog(@"coucou66");
    return YES;
}


/*
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if( [textField.superview.superview isMemberOfClass:[MovieEditorGeneralCell class]])
    {
        MovieEditorGeneralCell *cell = (MovieEditorGeneralCell*) textField.superview.superview;
        CGRect rec = textField.frame;
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

            // either one of the two, depending on if your view controller is the initial one
            
        
        }
    }
}
*/
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    DLog(@"coucou3");

    if( [textField.superview.superview isMemberOfClass:[MovieEditorGeneralCell class]])
    {

        MovieEditorGeneralCell *cell = (MovieEditorGeneralCell*) textField.superview.superview;
        
        if([cell.associatedKey isEqualToString:@"resolution"]){
            DLog(@"coucou4");

            //UIPickerView *picker = [[UIPickerView alloc] init];
            //[self.view endEditing:YES];
            //[self.view endEditing:NO];
            //[textField resignFirstResponder];
            //[popover presentPopoverFromRect:textField.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
            
            CGRect rec = textField.frame;
            rec = [self.parentViewController.view convertRect:rec fromView:textField.superview.superview];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            
            UINavigationController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Resolution Navigation Controller"];

            UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:vc];
            DLog(@"FRAME: o.x:%f, o.y:%f, h:%f, w:%f", rec.origin.x, rec.origin.y, rec.size.height, rec.size.width);
            [popover presentPopoverFromRect:rec inView:self.parentViewController.view permittedArrowDirections:UIPopoverArrowDirectionLeft
                                   animated:YES];
            _pc2 = popover;
            [vc.navigationController setHidesBottomBarWhenPushed:YES];
            
            ResolutionPickerVC *resolutionPicker = (ResolutionPickerVC *)[vc.childViewControllers lastObject];
            resolutionPicker.delegate = self;
            resolutionPicker.popover = popover;
            
            [textField setInputView:(UIView *)resolutionPicker];

            return NO;
            // either one of the two, depending on if your view controller is the initial one
            
            
        }
    }
    return YES;
}










/****************************************
 RateViewCell en SegmentedControl: indicates if use has watched the movie
 ****************************************/
#pragma mark - methode pour SegmentedControl
- (IBAction)segmentControlChanged:(UISegmentedControl *)sender;
{
    DLog(@"segmentControlChanged !!!");
    long value = [sender selectedSegmentIndex];
    DLog(@"value entered: %@", [NSNumber numberWithInt:value]);
    [_movieInformation setValue:[NSString stringWithFormat:@"%ld", value] forKey:@"viewed"];
}



#pragma mark - RateViewCellDelegate

-(void)rateChangeForKey:(NSString *)key newRate:(float)rate{
    DLog(@"rateChageForKey: %@, newRate:%f", key, rate);
    [_movieInformation setValue:[NSString stringWithFormat:@"%f", rate] forKey:key];
}





/****************************************
 Image picker: To pick image for movie poster
 ****************************************/

#pragma mark - image picker

- (IBAction)pickImage:(id)sender{
    
    [ALAssetsLibrary authorizationStatus];
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    __block BOOL accessFree = false;
    
    
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (*stop) {
            return ;
        }
        accessFree = YES;
        *stop = TRUE;
    } failureBlock:^(NSError *error) {
        accessFree = NO;
    }];
    
    
    if(accessFree == true)
    {
        
        UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
        [mediaUI setDelegate:self];
        [mediaUI setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [mediaUI setAllowsEditing:NO];
        
        UIViewController *view = [[UIViewController  alloc] init];
        
        
        
        //mediaUI.navigationItem.leftBarButtonItem = backButton;
        //mediaUI.navigationController.navigationItem.leftBarButtonItem = backButton;
        
        
        UIPopoverController *pc = [[UIPopoverController alloc] initWithContentViewController:view];
        CGRect fr = [sender frame];
        fr.origin.y = fr.origin.y + 50;
        [pc presentPopoverFromRect:fr inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        
        //_picker = mediaUI;
        _pc = pc;
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Access denied" message:@"Please give access to your photo library" delegate:NULL cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
    }
    //[picker toolbar]
}

- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    UIImage *originalImage;//, *editedImage, *imageToUse;
    

    originalImage = (UIImage *) [info objectForKey:
                                 UIImagePickerControllerOriginalImage];

    [_movieInformation setValue:originalImage forKey:@"big_picture"];
    [self.tableView reloadData];
    
    [self.pc dismissPopoverAnimated:YES];
    picker = nil;
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    //[picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:true completion:nil];
}


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    //viewController.title = @"connard";
    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel KEY", @"") style:UIBarButtonItemStylePlain target:self action:@selector(cancelPicker:)];
}




-(IBAction)cancelPicker:(id)sender{
    [_pc dismissPopoverAnimated:YES];
}


-(void)deleteImage
{
    DLog(@"deleteImage");
    [_movieInformation removeObjectForKey:@"big_picture"];
    [self.tableView reloadData];
}





/****************************************
 ResolutionPicker - Delegate
 ****************************************/

#pragma mark - ResolutionPicker Delegate

-(void)selectedResolution:(LMResolution)resolution
{
    DLog(@"resolutionSelected");
    [_movieInformation setObject:[NSString stringWithFormat:@"%d",resolution] forKey:@"resolution"];
    [self.tableView reloadData];
}




@end
