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
@property (nonatomic, strong) IBOutlet UIImageView *posterView;
@property (nonatomic, strong) IBOutlet UILabel *titleAndYearLabel;
@property (nonatomic, strong) IBOutlet UILabel *yearLabel;
@property (nonatomic, strong) IBOutlet UILabel *directorLabel;
-(void)setInfosWithTMDBMovieID:(NSString *)movieID;
-(void)resetCell;


@end
