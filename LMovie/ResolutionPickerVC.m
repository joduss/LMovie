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
    self.title = @"Choose resolution";
    [self.navigationController setToolbarHidden:NO animated:NO];
    DLog(@"blabla: %@", self.navigationController);
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


-(NSArray *)resolutionChoice
{
    if(_resolutionChoice == nil)
    {
        NSString *file = [[NSBundle mainBundle] pathForResource:@"MultipleChoices" ofType:@"plist"];
        _resolutionChoice = [[NSDictionary dictionaryWithContentsOfFile:file] valueForKey:@"Resolution"];
    }
    return _resolutionChoice;
}


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





#pragma mark - Popover Delegate
-(BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)thePopoverController{
    return NO;
}





- (IBAction)saveResolutionButtonPressed:(UIBarButtonItem *)sender {
    DLog(@"coucou");
    [_delegate selectedTitle:[_picker selectedRowInComponent:0]];
    [_popover dismissPopoverAnimated:YES];
}
@end
