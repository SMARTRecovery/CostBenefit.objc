//
//  SMRCostBenefitViewController.m
//  SMARTRecovery
//
//  Created by Aaron Schachter on 4/1/15.
//  Copyright (c) 2015 smartrecovery.org. All rights reserved.
//

#import "SMRCostBenefitViewController.h"
#import "SMRListCostBenefitsViewController.h"

@interface SMRCostBenefitViewController ()

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Hardcode for now.
    // @todo: Calculate length of each section based on properties.
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"Pros of doing";
        case 1:
            return @"Cons of doing";
        case 2:
            return @"Pros of not doing";
        case 3:
            return @"Cons of not doing";
        default:
            break;
    }
    return @"";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"costBenefitItemCell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"Placeholder %ld", indexPath.row];
    return cell;
}

- (IBAction)unwindToCostBenefit:(UIStoryboardSegue *)segue {

}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (sender != self.addButton) {
        UINavigationController *destNavVC = [segue destinationViewController];
        SMRListCostBenefitsViewController *destVC = (SMRListCostBenefitsViewController *)destNavVC.topViewController;
        [destVC setContext:self.context];
    }
}

@end
