//
//  SMRHomeViewController.m
//  CostBenefit
//
//  Created by Aaron Schachter on 12/19/15.
//  Copyright © 2015 smartrecovery.org. All rights reserved.
//

#import "SMRHomeViewController.h"
#import "SMRCostBenefit+methods.h"
#import "SMRCostBenefitViewController.h"
#import "SMRAboutCostBenefitViewController.h"
#import "SMREditCostBenefitViewController.h"
#import "SMRAboutSmartRecoveryViewController.h"

@interface SMRHomeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *costBenefits;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)aboutCBAButtonTouchUpInside:(id)sender;
- (IBAction)aboutSMARTButtonTouchUpInside:(id)sender;

@end

@implementation SMRHomeViewController

#pragma mark - NSObject

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    self = [super initWithNibName:@"SMRHomeView" bundle:nil];

    if (self) {
        _managedObjectContext = managedObjectContext;
    }

    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"CBA's";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonTapped:)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"rowCell"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    self.costBenefits = [SMRCostBenefit fetchAllCostBenefitsInContext:self.managedObjectContext];
    [self.tableView reloadData];
    if (self.costBenefits.count > 0) {
        self.tableView.bounces = YES;
    }
    else {
        self.tableView.bounces = NO;
    }
}

#pragma mark - SMRHomeViewController

- (void)addButtonTapped:(id)sender {
    SMREditCostBenefitViewController *addCostBenefitViewController = [[SMREditCostBenefitViewController alloc] initWithCostBenefitItem:nil isNew:YES managedObjectContext:self.managedObjectContext];
    UINavigationController *destNavVC = [[UINavigationController alloc] initWithRootViewController:addCostBenefitViewController];
    destNavVC.navigationBar.translucent = NO;
    [self.navigationController presentViewController:destNavVC animated:YES completion:nil];
}

- (IBAction)aboutCBAButtonTouchUpInside:(id)sender {
    SMRAboutCostBenefitViewController *destinationViewController = [[SMRAboutCostBenefitViewController alloc] initWithNibName:@"SMRAboutCostBenefitView" bundle:nil];
    [self.navigationController pushViewController:destinationViewController animated:YES];
}

- (IBAction)aboutSMARTButtonTouchUpInside:(id)sender {
    SMRAboutSmartRecoveryViewController *destinationViewController = [[SMRAboutSmartRecoveryViewController alloc] initWithNibName:@"SMRAboutSmartRecoveryView" bundle:nil];
    [self.navigationController pushViewController:destinationViewController animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.costBenefits.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rowCell" forIndexPath:indexPath];
    NSString *textLabel;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    SMRCostBenefit *costBenefit = self.costBenefits[indexPath.row];
    textLabel = costBenefit.title;
    cell.textLabel.text = textLabel;

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView
viewForFooterInSection:(NSInteger)section {
    if (self.costBenefits.count > 0) {
        return nil;
    }
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width - 32, 44)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, tableView.frame.size.width - 32, 144)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = UIColor.grayColor;
    titleLabel.numberOfLines = 0;
    titleLabel.text = @"A Cost Benefit Analysis (CBA) is a tool for exploring the short-term vs. long-term benefits associated with continuing or discontinuing an addictive behavior.";
    [footerView addSubview:titleLabel];
    return footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.costBenefits.count > 0) {
        return 0;
    }
    return 200;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SMRCostBenefit *costBenefit = self.costBenefits[indexPath.row];
    SMRCostBenefitViewController *costBenefitViewController = [[SMRCostBenefitViewController alloc] initWithCostBenefit:costBenefit managedObjectContext:self.managedObjectContext];
    [self.navigationController pushViewController:costBenefitViewController animated:YES];
}


@end
