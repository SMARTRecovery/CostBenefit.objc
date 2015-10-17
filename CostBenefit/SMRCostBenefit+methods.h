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

// Returns "Advantage" or "Disadvantage", based on boxNumber.
- (NSString *)getBoxDescriptor:(NSNumber *)boxNumber isPlural:(BOOL)isPlural;

// Gets entire box label based on number. e.g. "Advantage of NOT doing"
- (NSString *)getBoxLabelText:(NSNumber*)boxNumber isPlural:(BOOL)isPlural;

// Returns doing or using, based on the CostBenefit.type
- (NSString *)getVerb;

@end
