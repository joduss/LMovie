//
//  infoViewPanel.m
//  LMovie
//
//  Created by Jonathan Duss on 08.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "infoViewPanel.h"
@interface infoViewPanel ()
@property (strong, nonatomic) NSMutableDictionary *info;
@end


@implementation infoViewPanel

@synthesize tableView = _tableView;
@synthesize movieToEdit = _movieToEdit;
@synthesize movieManager = _movieManager;
@synthesize info = _info;



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(id)init{
    self = [[[NSBundle mainBundle] loadNibNamed:@"infoViewGeneralCell" owner:self options:nil] objectAtIndex:0];
    //self.tableView = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStyleGrouped];
    _info = [[NSMutableDictionary alloc] init];
    //[self.tableView setAllowsSelection:NO];
    for(NSString *key in _movieManager.allKey){
        if([key isEqualToString:@"picture"]){
            [_info setValue:[UIImage imageWithData:_movieToEdit.picture] forKey:@"picture"];
        }
        else {
            [_info setValue:[[_movieToEdit valueForKey:key] description] forKey:key];
        }
    }
    
    return self;
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
    DLog(@"section: %d, row: %d ", indexPath.section, indexPath.row);
    
    int row = indexPath.row;
    NSString *identifier = @""; //rempli plus tard
    
    if(indexPath.section == 0 && row == 0){
        identifier = @"picture cell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = cell.bounds;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        
        if([_info valueForKey:@"picture"] == nil){
            NSString *file = [[NSBundle mainBundle] pathForResource:@"emptyartwork_big" ofType:@"jpg"];
            imageView.image = [UIImage imageWithContentsOfFile:file];
        }
        else {
            DLog(@"Image mise");
            imageView.image = [_info valueForKey:@"picture"];
        }
        
        cell.backgroundView = imageView;
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
        
        if(cell == nil){
            cell = [[MovieEditorGeneralCell alloc] initWithStyle:UITableViewCellStateShowingEditControlMask reuseIdentifier:identifier];
        }
        
        //DLog(@"Array %@", sectionArray);
        //DLog(@"Populating cell: key %@, value: %@", key, value);
        cell.textField.text = [self.info valueForKey:key];
        cell.infoLabel.text = [dicoWithInfo valueForKey:@"infoLabel"];
        cell.textField.placeholder = [dicoWithInfo valueForKey:@"placeHolder"];
        [cell setAssociatedKey:key];
        
        DLog(@"Load key: %@, value: %@", key, [self.info valueForKey:key]);
        
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


@end
