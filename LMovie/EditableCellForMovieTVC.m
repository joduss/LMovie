//
//  EditableCellForMovieTVC.m
//  LMovie
//
//  Created by Jonathan Duss on 15.08.12.
//
//

#import "EditableCellForMovieTVC.h"

@interface EditableCellForMovieTVC ()

@end

@implementation EditableCellForMovieTVC


@synthesize valueEntered = _valueEntered;




- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

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
@end
