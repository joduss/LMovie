//
//  ResolutionPickerVC.m
//  LMovie
//
//  Created by Jonathan Duss on 04.09.12.
//
//

#import "ResolutionPickerVC.h"

@interface ResolutionPickerVC ()
@property (nonatomic, strong) NSArray *resolutionChoice;
@end

@implementation ResolutionPickerVC
@synthesize picker = _picker;


- (void)viewDidLoad
{
    [super viewDidLoad];
    _picker.delegate = self;
    _picker.dataSource = self;
    self.title = NSLocalizedString(@"Choose resolution KEY", @"");
    [self.navigationController setToolbarHidden:NO animated:NO];
    DLog(@"blabla: %@", self.navigationController);
    if(_forSearch != YES){
        _forSearch = NO;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.popover setDelegate:self];
}

- (void)viewDidUnload
{
    [self setPicker:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)setForSearch:(BOOL)forSearch
{
    _forSearch = forSearch;
    _resolutionChoice = nil;
    [_picker reloadAllComponents];
}






/****************************************
 PICKER delegate
 ****************************************/
#pragma mark - Picker Delegate et Datasource
-(int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0){
        return [self.resolutionChoice count];
    }
    else
        return 0;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [MovieManager resolutionToStringForResolution:row];
}


//chargement du choix des résolutions
-(NSArray *)resolutionChoice
{
    if(_resolutionChoice == nil)
    {
        NSString *file = [[NSBundle mainBundle] pathForResource:@"MultipleChoices" ofType:@"plist"];
        NSMutableArray *array = [[[NSDictionary dictionaryWithContentsOfFile:file] valueForKey:[@"Resolution-"  stringByAppendingString:[[NSLocale preferredLanguages] objectAtIndex:0]]] mutableCopy];
        if(!_forSearch){
            [array removeLastObject];
        }
        _resolutionChoice = [array copy];
    }
    return _resolutionChoice;
}





/****************************************
 POPOVER delegate
 ****************************************/
#pragma mark - Popover Delegate
-(BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)thePopoverController{
    return NO;
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.popover = nil;
}




/****************************************
 IBACTIONS
 ****************************************/
#pragma mark - IBAction
- (IBAction)saveResolutionButtonPressed:(UIBarButtonItem *)sender {
    DLog(@"coucou");
    [_delegate selectedResolution:[_picker selectedRowInComponent:0]];
    [_popover dismissPopoverAnimated:YES];
}
@end
