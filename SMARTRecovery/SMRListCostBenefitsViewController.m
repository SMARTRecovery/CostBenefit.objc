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

@interface SMRListCostBenefitsViewController ()

@property (strong, nonatomic) NSMutableArray *costBenefits;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"costBenefitCell" forIndexPath:indexPath];

    SMRCostBenefit *costBenefit = self.costBenefits[indexPath.row];
    cell.textLabel.text = costBenefit.title;

    return cell;
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue
{
    [self viewDidAppear:YES];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *destNavVC = (UINavigationController *)[segue destinationViewController];
    if (sender == self.addButton) {
        SMREditCostBenefitViewController *destVC = (SMREditCostBenefitViewController *)destNavVC.topViewController;
        [destVC setContext:self.context];
        [destVC setCostBenefit:nil];
    }
    else {
        SMRCostBenefitViewController *destVC = (SMRCostBenefitViewController *)destNavVC.topViewController;
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        [destVC setCostBenefit:self.costBenefits[indexPath.row]];
        [destVC setContext:self.context];
    }
}

@end
