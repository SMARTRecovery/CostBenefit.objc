//
//  SMRCostBenefit+methods.h
//  SMARTRecovery
//
//  Created by Aaron Schachter on 3/30/15.
//  Copyright (c) 2015 smartrecovery.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMRCostBenefit.h"

@interface SMRCostBenefit (methods)

+ (SMRCostBenefit *)createCostBenefitInContext:(NSManagedObjectContext *)context;

+ (NSMutableArray *)fetchAllCostBenefitsInContext:(NSManagedObjectContext *)context;

- (NSMutableArray *)fetchBoxes:(NSManagedObjectContext *)context;

@end
