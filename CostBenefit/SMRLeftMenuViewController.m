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
#import "SMRStaticViewController.h"
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
    if (section == 0) {
        return @"CBA's";
    }
    return @"Info";
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
        // Weird stuff can happen when deleting rows.
        // These cells can end up with the image and gray color,
        // so explicitly set the attributes here.
        cell.imageView.image = nil;
        cell.textLabel.textColor = [UIColor blackColor];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UINavigationController *destNavVC;
    if (indexPath.section == 0) {
        if (indexPath.row < [self.costBenefits count]) {
            destNavVC= [self.storyboard instantiateViewControllerWithIdentifier:@"costBenefitNavigationController"];
            SMRCostBenefitViewController *destVC = (SMRCostBenefitViewController *)destNavVC.topViewController;
            [destVC setCostBenefit:self.costBenefits[indexPath.row]];
            [destVC setContext:self.context];
        }
        else {
            destNavVC= [self.storyboard instantiateViewControllerWithIdentifier:@"editCostBenefitNavVC"];
            SMREditCostBenefitViewController *destVC = (SMREditCostBenefitViewController *)destNavVC.topViewController;
            [destVC setCostBenefit:nil];
            [destVC setContext:self.context];
        }
        [self.mm_drawerController setCenterViewController:destNavVC withCloseAnimation:YES completion:nil];
    }
    else {
        destNavVC= [self.storyboard instantiateViewControllerWithIdentifier:@"staticNavVC"];
        SMRStaticViewController *destVC = (SMRStaticViewController *)destNavVC.topViewController;
        if (indexPath.row == 0) {
            destVC.txtFileName = @"cba";
        }
        else {
            destVC.txtFileName = @"smart";
        }
        [self.mm_drawerController setCenterViewController:destNavVC withCloseAnimation:YES completion:nil];
    }
}

@end
