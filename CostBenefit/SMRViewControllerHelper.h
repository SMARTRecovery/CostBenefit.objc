//
//  SMRViewControllerHelpers.h
//  SMARTRecovery
//
//  Created by Aaron Schachter on 4/9/15.
//  Copyright (c) 2015 smartrecovery.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIViewController+MMDrawerController.h"
#import "SMRCostBenefit+methods.h"


@interface SMRViewControllerHelper : NSObject

+ (void)presentCostBenefit:(SMRCostBenefit *)costBenefit viewController:(UIViewController *)viewController context:(NSManagedObjectContext *)context drawer:(MMDrawerController *)drawer;

+ (void)presentHome:(UIViewController *)viewController context:(NSManagedObjectContext *)context;

@end
