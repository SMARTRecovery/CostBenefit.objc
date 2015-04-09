//
//  SMRViewControllerHelpers.m
//  SMARTRecovery
//
//  Created by Aaron Schachter on 4/9/15.
//  Copyright (c) 2015 smartrecovery.org. All rights reserved.
//

#import "SMRViewControllerHelpers.h"
#import "SMRCostBenefitViewController.h"

@implementation SMRViewControllerHelpers

+ (void)presentCostBenefit:(SMRCostBenefit *)costBenefit viewController:(UIViewController*)viewController context:(NSManagedObjectContext *)context {

    UINavigationController *destNavVC = [viewController.storyboard instantiateViewControllerWithIdentifier:@"costBenefitNavigationController"];
    SMRCostBenefitViewController *destVC = (SMRCostBenefitViewController *)destNavVC.topViewController;
    destVC.context = context;
    destVC.costBenefit = costBenefit;
    [viewController presentViewController:destNavVC animated:YES completion:nil];
}

@end
