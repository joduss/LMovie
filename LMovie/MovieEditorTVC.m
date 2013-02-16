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
@property (nonatomic) MovieEditorMode movieEditorMode;
@property (nonatomic, strong) Movie* movie;
@property MovieManager *movieManager;
@property (nonatomic, strong) NSString *aaa;



@end


@implementation MovieEditorTVC
@synthesize saveButton = _saveButton;
@synthesize cancelButton = _cancelButton;
//@synthesize movieToEdit = _movieToEdit;
@synthesize movieManager = _movieManager;
@synthesize delegate = _delegate;
@synthesize popover = _popover; 
//@synthesize valueEntered = _valueEntered;
@synthesize pc = _pc;
@synthesize addedFromTMDB = _addedFromTMDB;
@synthesize movieEditorMode = _movieEditorMode;
@synthesize aaa = _aaa;


-(id)init{
    self = [super init];
    [self setMovieManager:[MovieManager instance]];
    return self;
}

-(void)createAAA:(NSString *)string{
    _aaa = string;
}



- (void)viewDidLoad
{ 
    
    [super viewDidLoad];
    /*if(!_valueEntered)
    {
        _valueEntered = [[NSMutableDictionary alloc] init];
    }*/
    [self.tableView setAllowsSelection:NO];
    [self.navigationItem setHidesBackButton:YES animated:YES];
    self.saveButton.title = NSLocalizedString(@"Save KEY", @"");
    self.cancelButton.title = NSLocalizedString(@"Cancel KEY", @"");


    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    
    [super viewWillAppear:animated];
    self.popover.delegate = self;
    /*if(_movieToEdit != nil){
        self.title = NSLocalizedString(@"Modify movie KEY", @"");
        for(NSString *key in [MovieManagerUtils allKey]){
            
#warning tu te fous de moi???? Adapte moi ca mieux
            if([key isEqualToString:@"big_picture_path"]){
                DLog(@"Big_picture_path: %@", _movieToEdit.big_picture_path);
                [_valueEntered setValue:_movieToEdit.big_picture_path forKey:key];
            }
            else if([key isEqualToString:@"mini_picture_path"]){
                [_valueEntered setValue:_movieToEdit.mini_picture_path forKey:key];
            }
            else {
                [_valueEntered setValue:[[_movieToEdit valueForKey:key] description] forKey:key];
            }
        }
    }
    else
    {
        self.title = NSLocalizedString(@"Add movie KEY", @"");
    }*/
    self.modalInPopover = YES;
}


-(void)createMovie{
    self.title = NSLocalizedString(@"Add movie KEY", @"");
    _movie = [_movieManager newMovie];
    _movieEditorMode = MovieEditorModeAddFromNull;
}


-(void)modifyMovie:(Movie *)movie{
    self.title = NSLocalizedString(@"Add movie KEY", @"");
    _movie = movie;
    _movieEditorMode = MovieEditorModeModify;
}


-(void)viewInfoTMDBBeforeCreatingMovie:(TMDBMovie *)tmdbMovie{

    self.title = NSLocalizedString(@"Modify movie KEY", @"");
    [self setMovie:[_movieManager newMovie]];
    [tmdbMovie completeInfoForMovie:_movie];
    _movieEditorMode = MovieEditorModezMovieEditorModeAddFromTMDB;
    
    DLog(@"JONATHAN LOAD et movie %@", [_movie description]);
    DLog(@"JONATHAN LOAD ET aaa: %@", _aaa);
    
}



-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.modalInPopover = YES;
    
    DLog(@"MOVIE JONATHAN: %@", [_movie description]);
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


-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}






/****************************************
 TABLEVIEW
 ****************************************/
#pragma mark - Table view data source

- (int)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[MovieManagerUtils keyOrderedBySection] objectAtIndex:section] count];
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"section: %d, row: %d ", indexPath.section, indexPath.row);
    
    
    int row = indexPath.row;
    NSString *identifier = @""; //rempli plus tard
    
    if(indexPath.section == 0 && row == 0){
        identifier = @"picture cell";
        MovieEditorPictureCell * cell = (MovieEditorPictureCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
     
        cell.cellImage = [_movie big_cover];

        [cell.selectButton addTarget:self action:@selector(pickImage:) forControlEvents:UIControlEventTouchUpInside];
        [cell.deleteImageButton addTarget:self action:@selector(deleteImage) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else {
 
        
        
        NSString *key = [MovieManagerUtils keyAtIndexPath:indexPath];


        UITableViewCell *cellToReturn;
        
        identifier = @"general cell movieEditor";
        
        //Pour cellule VIEWED
        if([key isEqualToString:@"viewed"]){
            
            identifier = @"viewed cell movieEditor";
            MovieEditorViewedCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            [cell.infoLabel setText:[MovieManagerUtils labelForKey:key]];
            
            //gère les segments
            [cell.choice removeAllSegments];
            [cell.choice insertSegmentWithTitle:NSLocalizedString(@"No KEY", @"") atIndex:ViewedNO animated:NO];
            [cell.choice insertSegmentWithTitle:NSLocalizedString(@"Yes KEY", @"") atIndex:ViewedYES animated:NO];
            [cell.choice insertSegmentWithTitle:NSLocalizedString(@"? KEY", @"") atIndex:ViewedMAYBE animated:NO];
            
            [cell.choice addTarget:self action:@selector(segmentControlChanged:) forControlEvents:UIControlEventValueChanged];
            int viewedValue = [_movie.viewed intValue];
            if(viewedValue < 0 || viewedValue > 2 || !_movie.viewed){
                viewedValue = ViewedMAYBE;
                [_movie setViewed:[NSNumber numberWithInt:viewedValue]];
                //[_valueEntered setValue:[NSString stringWithFormat:@"%d", viewedValue] forKey:@"viewed"];
            }
            cell.choice.selectedSegmentIndex = viewedValue;
            
            cellToReturn = cell;
            
        }
        //pour user_rate et tmdb_rate
        else if ([key isEqualToString:@"user_rate"]){
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
            [cell configureCellWithRate:[_movie.user_rate floatValue]];
            
            
            cellToReturn = cell;

        }
        else {
            identifier = @"general cell movieEditor";
            MovieEditorGeneralCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if([key isEqualToString:@"resolution"])
            {
                NSString *title = [MovieManagerUtils resolutionToStringForResolution:[[_movie valueForKey:key] intValue]];
                cell.textField.text = title;
            }
            else
            {
                NSString *text = [NSString stringWithFormat:@"%@", [_movie valueForKey:key] ];
                if ([text isEqualToString:@"(null)"]){
                    text = @"";
                }
                cell.textField.text = text;
            }
            cell.infoLabel.text = [MovieManagerUtils labelForKey:key];
            cell.textField.placeholder = [MovieManagerUtils placeholderForKey:key];
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
        
        
        DLog(@"Load key: %@, value: %@", key, [_movie valueForKey:key]);
        
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
- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender {
    //[_delegate actionExecuted:ActionReset];
    
    [self.view endEditing:YES];

    if(_movieEditorMode == MovieEditorModeAddFromNull || _movieEditorMode == MovieEditorModezMovieEditorModeAddFromTMDB){
        [_movieManager deleteMovie:_movie];
    }
    else
    {
        [_movie revertChanges];
    }
    
    [self.popover dismissPopoverAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}



- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender {
    
    [self.view endEditing:YES];

    
    //DLog(@"value entered lorsque save est pressé: %@", [_valueEntered description]);

    
    BOOL error1 = NO;
    BOOL error2 = NO;
    
#warning faire tout ça dans movie+info
    
    //test: title est différente de rien
    NSString *test1 = _movie.title;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[^a-zA-Z0-9]"];
    error1 = [test1 isEqualToString:@""] || test1 == nil || [predicate evaluateWithObject:test1]; 
    
    /*if(error1){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Error KEY", @"")  
                                                       message:NSLocalizedString(@"Title cannot be empty KEY", @"") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        
        //Test de la condition: année est un nombre
        NSString *test2 = _movie.year;
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        error2 = ([formatter numberFromString:test2] == nil);
        //DLog(@"From %@ -> formater -> %@", test2, [formatter numberFromString:test2]);
        if (error2) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Error KEY", @"") 
                                                           message:NSLocalizedString(@"Year must be a number", @"") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }*/
    
    //if(error1 != YES && error2 != YES){
        DLog(@"SavebuttonPressed: no error up here");
        

        
#warning ajouter test si case ok
        
        [_movieManager saveContext];
        
        //si le film à éditer existe, on modifie l'objet, sinon, crée un nouveau objet
        /*if(_movieToEdit == nil || _addedFromTMDB){
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
        */
        if(self.popover){
            [self.popover dismissPopoverAnimated:YES];
        }
        else{
            [self dismissModalViewControllerAnimated:YES];
            [self.navigationController popViewControllerAnimated:YES];
        }
    //}
    
    
}




/****************************************
 Textfield Delegate Methodes
 ****************************************/

#pragma mark - textfield delegate methods
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    MovieEditorGeneralCell *cell = (MovieEditorGeneralCell *) [[textField superview] superview];
    if(cell != nil && cell.associatedKey != nil){
        if([[_movie valueForKey:cell.associatedKey] isKindOfClass:[NSString class]]){
            [_movie setValue:textField.text forKey:cell.associatedKey];
        } else if([[_movie valueForKey:cell.associatedKey] isKindOfClass:[NSNumber class]]){
            [_movie setValue:[textField.text nsNumber] forKey:cell.associatedKey];
        }
        [textField resignFirstResponder];
        DLog(@"Value Entered set for: key: %@ and value: %@", cell.associatedKey, textField.text);
    }
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


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
 RateViewCell en SegmentedControl
 ****************************************/
#pragma mark - methode pour SegmentedControl
- (IBAction)segmentControlChanged:(UISegmentedControl *)sender;
{
    DLog(@"segmentControlChanged !!!");
    int value = [sender selectedSegmentIndex];
    DLog(@"value entered: %@", [NSNumber numberWithInt:value]);
    [_movie setValue:[NSNumber numberWithInt:value] forKey:@"viewed"];
}



#pragma mark - RateViewCellDelegate

-(void)rateChangeForKey:(NSString *)key newRate:(float)rate{
    DLog(@"rateChageForKey: %@, newRate:%f", key, rate);
    [_movie setValue:[NSString stringWithFormat:@"%f", rate] forKey:key];
}





/****************************************
 Image picker
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
        // TODO : access granted
        accessFree = YES;
        *stop = TRUE;
    } failureBlock:^(NSError *error) {
        // TODO: User denied access. Tell them we can't do anything.
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
#warning sauver image dans tempory directory et renvoyer le lien
    
#warning adapter
    //[_valueEntered setValue:originalImage forKey:@"big_picture_path"];
    [self.tableView reloadData];
    
    [self.pc dismissPopoverAnimated:YES];
    picker = nil;
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissModalViewControllerAnimated:YES];
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
    Cover *cover = (Cover *)_movie.cover;
    [cover setMini_cover:[MovieManagerUtils defaultMiniCoverData]];
    [cover setBig_cover:[MovieManagerUtils defaultBigCoverData]];
    [self.tableView reloadData];
}





/****************************************
 ResolutionPicker - Delegate
 ****************************************/

#pragma mark - ResolutionPicker Delegate

-(void)selectedResolution:(LMResolution)resolution
{
    DLog(@"resolutionSelected");
    //[_valueEntered setObject:[NSString stringWithFormat:@"%d",resolution] forKey:@"resolution"];
    [self.tableView reloadData];
}




@end
