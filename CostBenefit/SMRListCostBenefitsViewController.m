//
//  SMRListCostBenefitsViewController.m
//  SMARTRecovery
//
//  Created by Aaron Schachter on 3/30/15.
//  Copyright (c) 2015 smartrecovery.org. All rights reserved.
//

#import "SMRListCostBenefitsViewController.h"
#import "SMREditCostBenefitViewController.h"
#import "SMRCostBenefit+methods.h"
#import "SMRCostBenefitViewController.h"
#import "MMDrawerBarButtonItem.h"

@interface SMRListCostBenefitsViewController ()

@property (strong, nonatomic) NSMutableArray *costBenefits;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SMRListCostBenefitsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
     self.costBenefits = [SMRCostBenefit fetchAllCostBenefitsInContext:self.context];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.costBenefits count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title;
    if (section == 0) {
        title = @"CBA's";
    }
    else {
        title = @"About";
    }
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"costBenefitCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        SMRCostBenefit *costBenefit = self.costBenefits[indexPath.row];
        cell.textLabel.text = costBenefit.title;
    }
    else {
        cell.textLabel.text = [NSString stringWithFormat:@"Row %ld", indexPath.row];
    }

    return cell;
}
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        UINavigationController *costBenefitNavVC = [self.storyboard instantiateViewControllerWithIdentifier:@"costBenefitNavigationController"];
        SMRCostBenefitViewController *costBenefitVC = (SMRCostBenefitViewController *)costBenefitNavVC.topViewController;
        [costBenefitVC setCostBenefit:self.costBenefits[indexPath.row]];
        [costBenefitVC setContext:self.context];
        [self.drawer setCenterViewController:costBenefitNavVC withCloseAnimation:YES completion:nil];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *destNavVC = (UINavigationController *)[segue destinationViewController];
    //if (sender == self.addButton) {
        SMREditCostBenefitViewController *destVC = (SMREditCostBenefitViewController *)destNavVC.topViewController;
        [destVC setContext:self.context];
        [destVC setCostBenefit:nil];
    //}
}

@end
