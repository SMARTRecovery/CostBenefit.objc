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
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SMRCostBenefitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.title = self.costBenefit.title;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self getItemTitles];
}

- (void) getItemTitles {
    self.items = [[NSMutableArray alloc] init];
    for (SMRCostBenefitItem *item in self.costBenefit.costBenefitItems) {
        [self.items addObject:item.title];
    }
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Hardcode for now.
    // @todo: Calculate length of each section based on properties.
    return [self.items count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *title;
    switch (section) {
        case 0:
            title = [NSString stringWithFormat:@"Advantages of %@", self.costBenefit.title];
            break;
        case 1:
            title = [NSString stringWithFormat:@"Disadvantages of %@", self.costBenefit.title];
            break;
        case 2:
            title = [NSString stringWithFormat:@"Advantages of NO %@", self.costBenefit.title];
            break;
        case 3:
            title = [NSString stringWithFormat:@"Disadvantages of NO %@", self.costBenefit.title];
            break;
        default:
            break;
    }
    return title;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"costBenefitItemCell" forIndexPath:indexPath];
    cell.textLabel.text = self.items[indexPath.row];
    return cell;
}

- (IBAction)unwindToCostBenefit:(UIStoryboardSegue *)segue {
    [self viewDidAppear:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *destNavVC = [segue destinationViewController];
    if (sender != self.addButton) {
        SMRListCostBenefitsViewController *destVC = (SMRListCostBenefitsViewController *)destNavVC.topViewController;
        [destVC setContext:self.context];
    }
    else {
        SMRCostBenefitItemViewController *destVC = (SMRCostBenefitItemViewController *)destNavVC.topViewController;
        [destVC setContext:self.context];
        [destVC setCostBenefit:self.costBenefit];
    }
}

@end
