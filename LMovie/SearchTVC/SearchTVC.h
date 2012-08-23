//
//  SearchTVC.h
//  LMovie
//
//  Created by Jonathan Duss on 15.08.12.
//
//

#import <UIKit/UIKit.h>
#import "MovieManager.h"
#import "MovieEditorGeneralCell.h"
#import "RateViewCell.h"
#import "MovieEditorViewedCell.h"
#import "EditableCellForMovieTVC.h"

@protocol SearchTVCDelegate <NSObject>
-(void)executeSearchWithInfo:(NSDictionary *)info;

@end


@interface SearchTVC : EditableCellForMovieTVC <RateViewCellDelegate>
@property  (nonatomic, strong)  MovieManager *movieManager;
@property (nonatomic, strong) id <SearchTVCDelegate> delegate;
- (IBAction)segmentControlChanged:(UISegmentedControl *)sender;
- (IBAction)SearchButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)resetButtonPressed:(UIBarButtonItem *)sender;

@end



