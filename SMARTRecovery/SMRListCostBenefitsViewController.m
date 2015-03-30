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

@interface SMRListCostBenefitsViewController ()

@end

@implementation SMRListCostBenefitsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
     NSMutableArray *costBenefits = [SMRCostBenefit fetchAllCostBenefitsInContext:self.context];
     NSLog(@"%@", costBenefits);
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue
{
    SMREditCostBenefitViewController *source = [segue sourceViewController];
    if (source.op != nil) {
        SMRCostBenefit *costBenefit;
        costBenefit = [SMRCostBenefit createCostBenefitInContext:self.context];
        costBenefit.title = source.costBenefitTitle;
        NSLog(@"source.costBenefitTitle = %@", source.costBenefitTitle);
        NSError *error;
        [self.context save:&error];
    }

//        [self.tableView reloadData];
//        [self viewDidLoad];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
