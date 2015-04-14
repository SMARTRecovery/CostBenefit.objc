//
//  SMRCostBenefitViewController.m
//  SMARTRecovery
//
//  Created by Aaron Schachter on 4/1/15.
//  Copyright (c) 2015 smartrecovery.org. All rights reserved.
//

#import "SMRCostBenefitViewController.h"
#import "SMRListCostBenefitsViewController.h"
#import "SMRCostBenefitItemViewController.h"
#import "SMRCostBenefitItem+methods.h"
#import "SMREditCostBenefitViewController.h"
#import "SMRViewControllerHelper.h"

@interface SMRCostBenefitViewController ()

@property (strong, nonatomic) NSMutableArray *boxes;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SMRCostBenefitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.boxes = [[NSMutableArray alloc] init];
    for (int i=0; i<4; i++) {
        [self.boxes addObject:[[NSMutableArray alloc] init]];
    }

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.title = self.costBenefit.title;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.boxes = [self.costBenefit fetchBoxes:self.context];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *boxItems = self.boxes[section];
    if ([boxItems count] > 0) {
        return [boxItems count];
    }
    // Return 1 for empty placeholder cell.
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *title;
    NSString *verb = [self.costBenefit getVerb];

    switch (section) {
        case 0:
            title = [NSString stringWithFormat:@"Advantages of %@", verb];
            break;
        case 1:
            title = [NSString stringWithFormat:@"Disadvantages of %@", verb];
            break;
        case 2:
            title = [NSString stringWithFormat:@"Advantages of NOT %@", verb];
            break;
        case 3:
            title = [NSString stringWithFormat:@"Disadvantages of NOT %@", verb];
            break;
        default:
            break;
    }
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"costBenefitItemCell" forIndexPath:indexPath];

    NSMutableArray *boxItems = self.boxes[indexPath.section];
    if ([boxItems count] == 0) {
        cell.textLabel.text = @"(None added)";
        cell.detailTextLabel.text = @" ";
        [cell setUserInteractionEnabled:NO];
        return cell;
    }

    SMRCostBenefitItem *item = boxItems[indexPath.row];
    cell.textLabel.text = item.title;
    NSString *detail = @"Short-term";
    if ([item.isLongTerm boolValue]) {
        detail = @"Long-term";
    }
    cell.detailTextLabel.text = detail;
    [cell setUserInteractionEnabled:YES];
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *destNavVC = [segue destinationViewController];
    if (sender == self.backButton) {
        SMRListCostBenefitsViewController *destVC = (SMRListCostBenefitsViewController *)destNavVC.topViewController;
        [destVC setContext:self.context];
    }
    else if (sender == self.editButton) {
        SMREditCostBenefitViewController *destVC = (SMREditCostBenefitViewController *)destNavVC.topViewController;
        [destVC setContext:self.context];
        [destVC setCostBenefit:self.costBenefit];
    }
    else {
        SMRCostBenefitItemViewController *destVC = (SMRCostBenefitItemViewController *)destNavVC.topViewController;
        [destVC setContext:self.context];
        [destVC setCostBenefit:self.costBenefit];
        [destVC setOp:@"insert"];
        if (sender != self.addButton) {
            UITableViewCell *cell = (UITableViewCell *)sender;
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            NSMutableArray *boxItems = self.boxes[indexPath.section];
            [destVC setCostBenefitItem:boxItems[indexPath.row]];
            [destVC setOp:@"update"];
        }
    }
}

@end
