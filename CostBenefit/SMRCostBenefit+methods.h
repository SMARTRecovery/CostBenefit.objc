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

- (NSString *)getBoxDescriptor:(NSNumber *)boxNumber isPlural:(BOOL)isPlural;

- (NSString *)getBoxLabelText:(NSNumber*)boxNumber isPlural:(BOOL)isPlural;

- (NSString *)getVerb;

@end
