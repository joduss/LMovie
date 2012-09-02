//
//  TMDBSearchTVC.h
//  LMovie
//
//  Created by Jonathan Duss on 24.08.12.
//
//

#import <UIKit/UIKit.h>
#import "TMDBSearchCell.h"

@interface TMDBSearchTVC : UITableViewController <UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
