//
//  SMRCostBenefitPageViewController.m
//  CostBenefit
//
//  Created by Aaron Schachter on 11/21/15.
//  Copyright © 2015 smartrecovery.org. All rights reserved.
//

#import "SMRCostBenefitViewController.h"
#import "SMRCostBenefitBoxViewController.h"
#import "SMREditCostBenefitViewController.h"
#import <IonIcons.h>

@interface SMRCostBenefitViewController () <UIPageViewControllerDataSource>

@property (strong, nonatomic) NSMutableArray *boxViewControllers;
@property (strong, nonatomic, readwrite) SMRCostBenefit *costBenefit;
@property (strong, nonatomic) SMRCostBenefitBoxViewController *currentBoxViewController;
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
    [self loadItems];

    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.dataSource = self;
    [self.pageViewController view].frame = [[self view] bounds];
    [self.pageViewController setViewControllers:[NSArray arrayWithObject:self.boxViewControllers[0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    self.currentBoxViewController = self.boxViewControllers[0];
    [self.pageViewController addChildViewController:self.boxViewControllers[0]];
    [[self view] addSubview:[self.pageViewController view]];
    [self.pageViewController didMoveToParentViewController:self];

    UIImage *menuImage = [IonIcons imageWithIcon:@"\uf46a" size:22.0f color:self.view.tintColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:menuImage style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonTapped:)];

    [self styleView];
}


#pragma mark - SMRCostBenefitViewController

- (void)styleView {
    self.pageViewController.view.backgroundColor = UIColor.whiteColor;
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor colorWithRed:0.867 green:0.867 blue:0.867 alpha:1];
    pageControl.currentPageIndicatorTintColor = self.view.tintColor;
}

- (void)loadItems {
    _boxViewControllers = [[NSMutableArray alloc] init];
    for (int i = 0; i < 4; i++) {
        SMRCostBenefitBoxViewController *boxVC = [[SMRCostBenefitBoxViewController alloc] initWithCostBenefitViewController:self boxNumber:[NSNumber numberWithInt:i] managedObjectContext:self.managedObjectContext];
        [_boxViewControllers addObject:boxVC];
        [boxVC reloadData];
    }
}

- (void)menuButtonTapped:(id)sender {
    UIAlertController *menuAlertController = [UIAlertController alertControllerWithTitle:nil message:nil                                                              preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *editAlertAction = [UIAlertAction actionWithTitle:@"Edit CBA" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        SMREditCostBenefitViewController *editCostBenefitViewController = [[SMREditCostBenefitViewController alloc] initWithCostBenefitItem:self.costBenefit isNew:NO managedObjectContext:self.managedObjectContext];
        UINavigationController *destNavVC = [[UINavigationController alloc] initWithRootViewController:editCostBenefitViewController];
        destNavVC.navigationBar.translucent = NO;
        [self.navigationController presentViewController:destNavVC animated:YES completion:nil];
    }];

    UIAlertAction *cancelAlertAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        [menuAlertController dismissViewControllerAnimated:YES completion:nil];
    }];

    [menuAlertController addAction:editAlertAction];
    [menuAlertController addAction:cancelAlertAction];
    [self presentViewController:menuAlertController animated:YES completion:nil];
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    _managedObjectContext = managedObjectContext;
    self.title = self.costBenefit.title;
    for (int i=0; i < 4; i++) {
        SMRCostBenefitBoxViewController *boxVC = self.boxViewControllers[i];
        boxVC.managedObjectContext = managedObjectContext;
        [boxVC reloadData];
    }
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    SMRCostBenefitBoxViewController *boxVC = (SMRCostBenefitBoxViewController *)viewController;
    if (boxVC.boxNumber.intValue == 3) {
        return nil;
    }
    self.currentBoxViewController = self.boxViewControllers[boxVC.boxNumber.intValue + 1];
    return self.currentBoxViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    SMRCostBenefitBoxViewController *boxVC = (SMRCostBenefitBoxViewController *)viewController;
    if (boxVC.boxNumber.intValue == 0) {
        return nil;
    }
    self.currentBoxViewController = self.boxViewControllers[boxVC.boxNumber.intValue - 1];
    return self.currentBoxViewController;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    SMRCostBenefitBoxViewController *boxVC = (SMRCostBenefitBoxViewController *)[pageViewController.viewControllers objectAtIndex:0];
    return [boxVC.boxNumber integerValue];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return 4;
}

@end
