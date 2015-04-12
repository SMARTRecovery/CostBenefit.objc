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

- (NSMutableArray *)fetchBoxes {
    NSMutableArray *boxes = [[NSMutableArray alloc] init];
    for (int i=0; i<4; i++) {
        [boxes addObject:[[NSMutableArray alloc] init]];
    }
    for (SMRCostBenefitItem *item in self.costBenefitItems) {
        NSNumber *boxNumber = item.boxNumber;
        NSMutableArray *boxItems = boxes[[boxNumber intValue]];
        [boxItems addObject:item];
    }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"created" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    // Sort each box by created.
    for (int i=0; i<4; i++) {
        NSArray *boxItems = boxes[i];
        boxItems = [boxItems sortedArrayUsingDescriptors:sortDescriptors];
        NSLog(@"sorted %@", boxItems);
    }
    return boxes;
}

@end
