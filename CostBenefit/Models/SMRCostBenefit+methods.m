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

+ (SMRCostBenefit *)createCostBenefitInContext:(NSManagedObjectContext *)context {
    return [NSEntityDescription insertNewObjectForEntityForName:@"SMRCostBenefit" inManagedObjectContext:context];
}

+ (NSMutableArray *)fetchAllCostBenefitsInContext:(NSManagedObjectContext *)context {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SMRCostBenefit" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateCreated" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    NSError *error = nil;
    return (NSMutableArray *)[context executeFetchRequest:fetchRequest error:&error];
}

- (NSMutableArray *)loadItemsForBoxNumber:(NSNumber *)boxNumber managedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SMRCostBenefitItem" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(costBenefit == %@) AND (boxNumber == %@)", self, boxNumber];
    [fetchRequest setPredicate:predicate];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"seq" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    NSError *error = nil;
    return (NSMutableArray *)[managedObjectContext executeFetchRequest:fetchRequest error:&error];
}

- (NSString *)getVerb {
    if ([self.type isEqualToString:@"activity"]) {
        return @"doing it";
    }
    return @"using";
}

- (NSString *)getBoxDescriptor:(NSNumber *)boxNumber isPlural:(BOOL)isPlural {
    NSString *descriptor;
    if ([boxNumber intValue] % 2 == 0) {
        if (isPlural) {
            descriptor = @"Advantages";
        }
        else {
            descriptor = @"An advantage";
        }

    }
    else {
        if (isPlural) {
            descriptor = @"Disadvantages";
        }
        else {
            descriptor = @"A disadvantage";
        }
    }

    return descriptor;
}

- (NSString *)getBoxLabelText:(NSNumber*)boxNumber isPlural:(BOOL)isPlural{
    NSString *action = @"";
    if ([boxNumber intValue] > 1) {
        action = @"NOT ";
    }
    NSString *descriptor = [self getBoxDescriptor:boxNumber isPlural:isPlural];
    if (isPlural) {
        return [NSString stringWithFormat:@"%@ of %@%@", descriptor, action, [self getVerb]];
    }
    NSString *singularVerbString;
    if ([self.type isEqualToString:@"activity"]) {
        singularVerbString = self.title;
    }
    else {
        singularVerbString = [NSString stringWithFormat:@"%@ %@", self.getVerb, self.title];
    }
    return [NSString stringWithFormat:@"%@ of %@%@", descriptor, action, singularVerbString];

}

@end
