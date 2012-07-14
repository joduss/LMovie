//
//  MovieEditorTVC.m
//  LMovie
//
//  Created by Jonathan Duss on 10.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovieEditorTVC.h"

@interface MovieEditorTVC ()
@property (nonatomic, strong) NSMutableDictionary *valueEntered;
@end

@implementation MovieEditorTVC
@synthesize movieToEdit = _movieToEdit;
@synthesize movieManager = _movieManager;
@synthesize delegate = _delegate;
@synthesize popover = _popover; 
@synthesize valueEntered = _valueEntered;

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
            if([key isEqualToString:@"picture"]){
                [_valueEntered setValue:[UIImage imageWithData:_movieToEdit.picture] forKey:@"picture"];
            }
            else {
                [_valueEntered setValue:[[_movieToEdit valueForKey:key] description] forKey:key];
            }
        }
    }
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
    NSString *identifier = @""; //rempli plus tard
    
    if(indexPath.section == 0 && row == 0){
            identifier = @"picture cell";
            MovieEditorPictureCell * cell = (MovieEditorPictureCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if([_valueEntered valueForKey:@"picture"] == nil){
            NSString *file = [[NSBundle mainBundle] pathForResource:@"emptyartwork_big" ofType:@"jpg"];
            cell.cellImage = [UIImage imageWithContentsOfFile:file];
        }
        else {
            cell.cellImage = [_valueEntered valueForKey:@"picture"];
        }
        
        
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
        cell.textField.text = [self.valueEntered valueForKey:key];
        cell.infoLabel.text = [dicoWithInfo valueForKey:@"infoLabel"];
        cell.textField.placeholder = [dicoWithInfo valueForKey:@"placeHolder"];
        [cell setAssociatedKey:key];
        cell.textField.delegate = self;
        
        NSLog(@"Load key: %@, value: %@", key, [self.valueEntered valueForKey:key]);
        
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







#pragma mark - Table view delegate


#pragma mark - IBAction methods
- (IBAction)resetButtonPressed:(UIBarButtonItem *)sender {
    //[_delegate actionExecuted:ActionReset];
    _valueEntered = [[NSMutableDictionary alloc] init];
}

- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender {
    
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
        //NSLog(@"From %@ -> formater -> %@", test2, [formatter numberFromString:test2]);
        if (error2) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Erreur" 
                                                           message:@"Year must be a number" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    
    if(error1 != YES && error2 != YES){
        NSLog(@"SavebuttonPressed: no error up here");
        
        //si le film à éditer existe, on modifie l'objet, sinon, crée un nouveau objet
        if(_movieToEdit == nil){
        [_movieManager insertMovieWithInformations:_valueEntered];
        }
        else {
            [_movieManager modifyMovie:_movieToEdit WithInformations:_valueEntered];
            [_delegate actionExecuted:ActionSaveModification];
        }
        [self.popover dismissPopoverAnimated:YES];
    }

    
}




#pragma mark - textfield delegate methods
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    MovieEditorGeneralCell *cell = (MovieEditorGeneralCell *) [[textField superview] superview];
    [_valueEntered setValue:textField.text forKey:cell.associatedKey];
    NSLog(@"Value Entered set for: key: %@ and value: %@", cell.associatedKey, textField.text);
}

@end
