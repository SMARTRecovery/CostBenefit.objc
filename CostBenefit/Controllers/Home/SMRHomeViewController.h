//
//  SMRHomeViewController.h
//  CostBenefit
//
//  Created by Aaron Schachter on 12/19/15.
//  Copyright © 2015 smartrecovery.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMRHomeViewController : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
