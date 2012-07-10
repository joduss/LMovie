//
//  infoViewPanel.h
//  LMovie
//
//  Created by Jonathan Duss on 08.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyMovie.h"
#import "MovieManager.h"

@interface infoViewPanel : UIView
@property NSManagedObject *movieToEdit;
@property MovieManager *movieManager;
@end
