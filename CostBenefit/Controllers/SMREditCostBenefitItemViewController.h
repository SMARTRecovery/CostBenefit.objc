//
//  SMREditCostBenefitItemViewController.h
//  CostBenefit
//
//  Created by Aaron Schachter on 11/23/15.
//  Copyright © 2015 smartrecovery.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMRCostBenefit+methods.h"
#import "SMRCostBenefitItem+methods.h"

@interface SMREditCostBenefitItemViewController : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (instancetype)initWithCostBenefitItem:(SMRCostBenefitItem *)costBenefitItem managedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
