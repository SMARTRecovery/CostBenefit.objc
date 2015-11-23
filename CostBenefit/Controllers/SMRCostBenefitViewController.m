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

@property (strong, nonatomic) NSMutableArray *boxViewControllers;
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
        int i = 0;
        _boxViewControllers = [[NSMutableArray alloc] init];
        for (NSArray *boxItems in [self.costBenefit fetchBoxes:self.managedObjectContext]) {
            SMRCostBenefitBoxViewController *boxVC = [[SMRCostBenefitBoxViewController alloc] initWithBoxNumber:[NSNumber numberWithInt:i] costBenefitItems:boxItems managedObjectContext:self.managedObjectContext];
            i++;
            [_boxViewControllers addObject:boxVC];
        }
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
    [self.pageViewController setViewControllers:[NSArray arrayWithObject:self.boxViewControllers[0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    [self.pageViewController addChildViewController:self.boxViewControllers[0]];
    [[self view] addSubview:[self.pageViewController view]];
    [self.pageViewController didMoveToParentViewController:self];
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    SMRCostBenefitBoxViewController *boxVC = (SMRCostBenefitBoxViewController *)viewController;
    if (boxVC.boxNumber.intValue == 3) {
        return nil;
    }
    return self.boxViewControllers[boxVC.boxNumber.intValue + 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    SMRCostBenefitBoxViewController *boxVC = (SMRCostBenefitBoxViewController *)viewController;
    if (boxVC.boxNumber.intValue == 0) {
        return nil;
    }
    return self.boxViewControllers[boxVC.boxNumber.intValue - 1];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    SMRCostBenefitBoxViewController *boxVC = (SMRCostBenefitBoxViewController *)[pageViewController.viewControllers objectAtIndex:0];
    return [boxVC.boxNumber integerValue];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return 4;
}

@end
