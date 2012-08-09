//
//  RateViewCell.h
//  LMovie
//
//  Created by Jonathan Duss on 06.08.12.
//
//

#import <UIKit/UIKit.h>
#import "RateView.h"


@protocol RateViewCellDelegate
-(void)rateChangeForKey:(NSString *)key newRate:(float)rate;
@end


@interface RateViewCell : UITableViewCell <RateViewDelegate>

@property (nonatomic, strong) IBOutlet RateView *rateView;
@property (nonatomic, strong) IBOutlet UILabel* infoLabel;
@property (nonatomic, assign) float rate;
@property (nonatomic, strong) id<RateViewCellDelegate> delegate;
@property (nonatomic, strong) NSString *key;

-(void)configureCellWithRate:(int)rate;
@end


