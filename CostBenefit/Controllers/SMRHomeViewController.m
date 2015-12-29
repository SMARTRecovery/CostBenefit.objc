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
#import "SMRStaticViewController.h"
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
}

#pragma mark - SMRHomeViewController

- (void)addButtonTapped:(id)sender {
    SMREditCostBenefitViewController *addCostBenefitViewController = [[SMREditCostBenefitViewController alloc] initWithCostBenefitItem:nil isNew:YES managedObjectContext:self.managedObjectContext];
    UINavigationController *destNavVC = [[UINavigationController alloc] initWithRootViewController:addCostBenefitViewController];
    destNavVC.navigationBar.translucent = NO;
    [self.navigationController presentViewController:destNavVC animated:YES completion:nil];
}

- (IBAction)aboutCBAButtonTouchUpInside:(id)sender {
    SMRStaticViewController *destinationViewController = [[SMRStaticViewController alloc] initWithContentFileName:@"cba"];
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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SMRCostBenefit *costBenefit = self.costBenefits[indexPath.row];
    SMRCostBenefitViewController *costBenefitViewController = [[SMRCostBenefitViewController alloc] initWithCostBenefit:costBenefit managedObjectContext:self.managedObjectContext];
    [self.navigationController pushViewController:costBenefitViewController animated:YES];
}


@end
