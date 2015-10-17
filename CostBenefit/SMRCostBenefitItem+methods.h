//
//  SMRCostBenefitItem+methods.h
//  SMARTRecovery
//
//  Created by Aaron Schachter on 4/2/15.
//  Copyright (c) 2015 smartrecovery.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMRCostBenefitItem.h"

@interface SMRCostBenefitItem (methods)

+ (SMRCostBenefitItem *)createCostBenefitItemInContext:(NSManagedObjectContext *)context;

@end
