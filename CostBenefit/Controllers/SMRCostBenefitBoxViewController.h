//
//  SMRCostBenefitBoxViewController.h
//  CostBenefit
//
//  Created by Aaron Schachter on 11/21/15.
//  Copyright © 2015 smartrecovery.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMRCostBenefit+methods.h"

@interface SMRCostBenefitBoxViewController : UIViewController

@property (strong, nonatomic) NSArray *costBenefitItems;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic, readonly) NSNumber *boxNumber;
@property (strong, nonatomic, readonly) SMRCostBenefit *costBenefit;

- (instancetype)initWithCostBenefit:(SMRCostBenefit *)costBenefit boxNumber:(NSNumber *)boxNumber costBenefitItems:(NSArray *)costBenefitItems managedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
