//
//  SMRCostBenefit.h
//  SMARTRecovery
//
//  Created by Aaron Schachter on 3/30/15.
//  Copyright (c) 2015 smartrecovery.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SMRCostBenefit : NSManagedObject

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSSet *costBenefitItems;
@property (nonatomic, retain) NSDate *dateCreated;
@property (nonatomic, retain) NSDate *dateUpdated;

@end

@interface SMRCostBenefit (CoreDataGeneratedAccessors)

- (void)addCostBenefitItemsObject:(NSManagedObject *)value;
- (void)removeCostBenefitItemsObject:(NSManagedObject *)value;
- (void)addCostBenefitItems:(NSSet *)values;
- (void)removeCostBenefitItems:(NSSet *)values;

@end
