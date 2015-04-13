//
//  SMRCostBenefitItem+methods.m
//  SMARTRecovery
//
//  Created by Aaron Schachter on 4/2/15.
//  Copyright (c) 2015 smartrecovery.org. All rights reserved.
//

#import "SMRCostBenefitItem+methods.h"

@implementation SMRCostBenefitItem (methods)

+(SMRCostBenefitItem *)createCostBenefitItemInContext:(NSManagedObjectContext *)context
{
    return [NSEntityDescription insertNewObjectForEntityForName:@"SMRCostBenefitItem" inManagedObjectContext:context];
}
@end
