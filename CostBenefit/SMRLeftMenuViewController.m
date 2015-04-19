//
//  SMRListCostBenefitsViewController.m
//  SMARTRecovery
//
//  Created by Aaron Schachter on 3/30/15.
//  Copyright (c) 2015 smartrecovery.org. All rights reserved.
//

#import "SMRLeftMenuViewController.h"
#import "SMREditCostBenefitViewController.h"
#import "SMRCostBenefit+methods.h"
#import "SMRCostBenefitViewController.h"
#import "MMDrawerBarButtonItem.h"

@interface SMRLeftMenuViewController ()

@property (strong, nonatomic) NSMutableArray *costBenefits;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SMRLeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.title = @"SMART Recovery";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
     self.costBenefits = [SMRCostBenefit fetchAllCostBenefitsInContext:self.context];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section > 0) {
        return 2;
    }
    return [self.costBenefits count] + 1;
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
        title = @"Info";
    }
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"costBenefitCell" forIndexPath:indexPath];
    NSString *textLabel;

    if (indexPath.section == 0) {
        if (indexPath.row == [self.costBenefits count]) {
            textLabel = @"New CBA";
            cell.imageView.image = [UIImage imageNamed:@"plus-26"];
            cell.textLabel.textColor = [UIColor grayColor];
        }
        else {
            cell.imageView.image = nil;
            SMRCostBenefit *costBenefit = self.costBenefits[indexPath.row];
            textLabel = costBenefit.title;
            cell.textLabel.textColor = [UIColor blackColor];
        }
    }

    else {
        if (indexPath.row == 0) {
            textLabel = @"About CBA's";
        }
        else {
            textLabel = @"About SMART Recovery";
        }
    }

    cell.textLabel.text = textLabel;
    return cell;
}
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        UINavigationController *costBenefitNavVC = [self.storyboard instantiateViewControllerWithIdentifier:@"costBenefitNavigationController"];
        SMRCostBenefitViewController *costBenefitVC = (SMRCostBenefitViewController *)costBenefitNavVC.topViewController;
        [costBenefitVC setCostBenefit:self.costBenefits[indexPath.row]];
        [costBenefitVC setContext:self.context];
        [costBenefitVC setDrawer:self.drawer];
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
