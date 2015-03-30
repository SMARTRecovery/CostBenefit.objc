//
//  SMRListCostBenefitsViewController.h
//  SMARTRecovery
//
//  Created by Aaron Schachter on 3/30/15.
//  Copyright (c) 2015 smartrecovery.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMRListCostBenefitsViewController : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *context;

- (IBAction)unwindToList:(UIStoryboardSegue *)segue;

@end
