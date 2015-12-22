//
//  SMRCostBenefitItem.h
//  SMARTRecovery
//
//  Created by Aaron Schachter on 3/30/15.
//  Copyright (c) 2015 smartrecovery.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SMRCostBenefit;

@interface SMRCostBenefitItem : NSManagedObject

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSNumber *seq;
@property (nonatomic, retain) NSNumber *boxNumber;
@property (nonatomic, retain) NSNumber *isLongTerm;
@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) SMRCostBenefit *costBenefit;

@end
