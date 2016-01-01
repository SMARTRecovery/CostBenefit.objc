//
//  SMREditCostBenefitViewController.h
//  CostBenefit
//
//  Created by Aaron Schachter on 12/19/15.
//  Copyright © 2015 smartrecovery.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMRCostBenefit+methods.h"

@interface SMREditCostBenefitViewController : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (instancetype)initWithCostBenefitItem:(SMRCostBenefit *)costBenefit isNew:(BOOL)isNew managedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
