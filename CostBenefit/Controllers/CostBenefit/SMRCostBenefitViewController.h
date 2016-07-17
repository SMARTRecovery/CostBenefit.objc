//
//  SMRCostBenefitPageViewController.h
//  CostBenefit
//
//  Created by Aaron Schachter on 11/21/15.
//  Copyright © 2015 smartrecovery.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMRCostBenefit+methods.h"

@interface SMRCostBenefitViewController : UIPageViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic, readonly) SMRCostBenefit *costBenefit;

- (instancetype)initWithCostBenefit:(SMRCostBenefit *)costBenefit managedObjectContext:(NSManagedObjectContext *)managedObjectContext;

- (void)loadItems;

@end
