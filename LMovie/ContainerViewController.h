//
//  ContainerViewController.h
//  LMovieB
//
//  Created by Jonathan Duss on 25.07.13.
//
//

#import <UIKit/UIKit.h>

@protocol containerDelegate
-(void)containerWillBeEmpty;
-(void)containerWillbeFilled;
@end


@interface ContainerViewController : UIViewController
@property (nonatomic, strong) NSString *segueIDToPerform;
@property (strong,nonatomic) id <containerDelegate> delegate;
@end
