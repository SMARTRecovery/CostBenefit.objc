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

@interface SMRCostBenefitViewController ()

@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) NSMutableArray *boxes;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
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
    [self setCostBenefitBoxes];
// currently unused
//    [self getItemTitles];
}

- (void) setCostBenefitBoxes {
    // Clear existing data.
    for (int i=0; i<4; i++) {
        self.boxes[i] = [[NSMutableArray alloc] init];
    }
    // Loop through costBenefitItems:
    for (SMRCostBenefitItem *item in self.costBenefit.costBenefitItems) {
        NSNumber *boxNumber = item.boxNumber;
        NSMutableArray *boxItems = self.boxes[[boxNumber intValue]];
        [boxItems addObject:item];
        [self.items addObject:item];
    }
    [self.tableView reloadData];
}

/* currently unused (displaying all boxes in VC for now)
- (void) getItemTitles {
    self.items = [[NSMutableArray alloc] init];
    for (SMRCostBenefitItem *item in self.costBenefit.costBenefitItems) {
        [self.items addObject:item];
    }
    [self.tableView reloadData];
}
*/

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
    switch (section) {
        case 0:
            title = [NSString stringWithFormat:@"Advantages of %@", self.costBenefit.title];
            title = @"Advantages of doing";
            break;
        case 1:
            title = [NSString stringWithFormat:@"Disadvantages of %@", self.costBenefit.title];
            title = @"Disadvantages of doing";
            break;
        case 2:
            title = [NSString stringWithFormat:@"Advantages of NO %@", self.costBenefit.title];
            title = @"Advantages of not doing";
            break;
        case 3:
            title = [NSString stringWithFormat:@"Disadvantages of NO %@", self.costBenefit.title];
            title = @"Disadvantages of not doing";
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
        cell.detailTextLabel.text = @"";
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

- (IBAction)unwindToCostBenefit:(UIStoryboardSegue *)segue {
    [self viewDidAppear:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *destNavVC = [segue destinationViewController];
    if (sender == self.backButton) {
        SMRListCostBenefitsViewController *destVC = (SMRListCostBenefitsViewController *)destNavVC.topViewController;
        [destVC setContext:self.context];
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
