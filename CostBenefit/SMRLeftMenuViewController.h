//
//  SMRListCostBenefitsViewController.h
//  SMARTRecovery
//
//  Created by Aaron Schachter on 3/30/15.
//  Copyright (c) 2015 smartrecovery.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+MMDrawerController.h"

@interface SMRLeftMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) MMDrawerController *drawer;

@end
