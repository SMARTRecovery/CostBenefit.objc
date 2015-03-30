//
//  SMRCostBenefit+methods.m
//  SMARTRecovery
//
//  Created by Aaron Schachter on 3/30/15.
//  Copyright (c) 2015 smartrecovery.org. All rights reserved.
//

#import "SMRCostBenefit+methods.h"

@implementation SMRCostBenefit (methods)

+(SMRCostBenefit *)createCostBenefitInContext:(NSManagedObjectContext *)context
{
    return [NSEntityDescription insertNewObjectForEntityForName:@"SMRCostBenefit" inManagedObjectContext:context];
}

+ (NSMutableArray *)fetchAllCostBenefitsInContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SMRCostBenefit"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error = nil;

    return (NSMutableArray *)[context executeFetchRequest:fetchRequest error:&error];
}
@end
