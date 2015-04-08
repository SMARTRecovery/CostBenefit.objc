//
//  SMREditCostBenefitViewController.m
//  SMARTRecovery
//
//  Created by Aaron Schachter on 3/30/15.
//  Copyright (c) 2015 smartrecovery.org. All rights reserved.
//

#import "SMREditCostBenefitViewController.h"

@interface SMREditCostBenefitViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
- (IBAction)saveTapped:(id)sender;

@end

@implementation SMREditCostBenefitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.costBenefit != nil) {
        self.title = @"Edit CBA";
        self.titleTextField.text = self.costBenefit.title;
    }
    else {
        self.costBenefit = [SMRCostBenefit createCostBenefitInContext:self.context];
        self.title = @"New CBA";
    }
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (sender == self.cancelButton) {
        return;
    }
    self.costBenefit.title = self.titleTextField.text;
    // Hard coded for now.
    // @todo: Select switch for substance|activity.
    self.costBenefit.type = @"substance";
    NSError *error;
    [self.context save:&error];
}


- (IBAction)saveTapped:(id)sender {
    // @todo: if inserted, load new CostBenefit, else redirect to view CostBenefit
}
@end
