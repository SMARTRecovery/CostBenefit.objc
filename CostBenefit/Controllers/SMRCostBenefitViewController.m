//
//  SMRCostBenefitPageViewController.m
//  CostBenefit
//
//  Created by Aaron Schachter on 11/21/15.
//  Copyright © 2015 smartrecovery.org. All rights reserved.
//

#import "SMRCostBenefitViewController.h"
#import "SMRCostBenefitBoxViewController.h"

@interface SMRCostBenefitViewController () <UIPageViewControllerDataSource>

@property (strong, nonatomic, readwrite) SMRCostBenefit *costBenefit;
@property (strong, nonatomic) UIPageViewController *pageViewController;

@end

@implementation SMRCostBenefitViewController

#pragma mark - NSObject

- (instancetype)initWithCostBenefit:(SMRCostBenefit *)costBenefit managedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    self = [super init];

    if (self) {
        _costBenefit = costBenefit;
        _managedObjectContext = managedObjectContext;
    }

    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = self.costBenefit.title;

    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.dataSource = self;
    [self.pageViewController view].frame = [[self view] bounds];

}


@end
