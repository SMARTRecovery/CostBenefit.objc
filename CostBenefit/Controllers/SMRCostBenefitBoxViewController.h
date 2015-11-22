//
//  SMRCostBenefitBoxViewController.h
//  CostBenefit
//
//  Created by Aaron Schachter on 11/21/15.
//  Copyright © 2015 smartrecovery.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMRCostBenefitBoxViewController : UIViewController

@property (strong, nonatomic) NSArray *costBenefitItems;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSNumber *boxNumber;

- (instancetype)initWithBoxNumber:(NSNumber *)boxNumber costBenefitItems:(NSArray *)costBenefitItems managedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
