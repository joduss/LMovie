//
//  TMDBSearchCell.h
//  LMovie
//
//  Created by Jonathan Duss on 24.08.12.
//
//

#import <UIKit/UIKit.h>
#import "utilities.h"
#import "TMDBMovie.h"

@interface TMDBSearchCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView *posterView;
@property (nonatomic, weak) IBOutlet UILabel *titleAndYearLabel;
@property (nonatomic, weak) IBOutlet UILabel *yearLabel;
@property (nonatomic, weak) IBOutlet UILabel *directorLabel;
-(void)setInfosWithTMDBMovieID:(NSString *)movieID;
-(void)resetCell;


@end
