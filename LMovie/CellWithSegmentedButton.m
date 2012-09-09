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

-(NSMutableDictionary*)valueEntered{
    DLog(@"dans valueEntered");
    if(_valueEntered){
        return _valueEntered;
    }
        _valueEntered = [[NSMutableDictionary alloc] init];
    
    return _valueEntered;
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
        [self.valueEntered setValue:textField.text forKey:cell.associatedKey];
        if ([textField.text isEqualToString:@""]) {
            DLog(@"removed last entry");
            [_valueEntered removeObjectForKey:cell.associatedKey];
        }
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
