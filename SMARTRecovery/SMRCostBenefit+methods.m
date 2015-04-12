//
//  SMRCostBenefit+methods.m
//  SMARTRecovery
//
//  Created by Aaron Schachter on 3/30/15.
//  Copyright (c) 2015 smartrecovery.org. All rights reserved.
//

#import "SMRCostBenefit+methods.h"
#import "SMRCostBenefitItem+methods.h"

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

- (NSMutableArray *)fetchBoxes:(NSManagedObjectContext *)context {
    NSMutableArray *boxes = [[NSMutableArray alloc] init];
    for (int i=0; i<4; i++) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

        NSEntityDescription *entity = [NSEntityDescription entityForName:@"SMRCostBenefitItem"
                                                  inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(costBenefit == %@) AND (boxNumber == %@)", self, [NSNumber numberWithInt:i]];
        [fetchRequest setPredicate:predicate];
        NSError *error = nil;

        NSMutableArray *boxItems = (NSMutableArray *)[context executeFetchRequest:fetchRequest error:&error];
        [boxes addObject:boxItems];
    }
    return boxes;
}

@end
