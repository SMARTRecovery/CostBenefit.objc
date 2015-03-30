//
//  SMREditCostBenefitViewController.m
//  SMARTRecovery
//
//  Created by Aaron Schachter on 3/30/15.
//  Copyright (c) 2015 smartrecovery.org. All rights reserved.
//

#import "SMREditCostBenefitViewController.h"

@interface SMREditCostBenefitViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
- (IBAction)saveTapped:(id)sender;

@end

@implementation SMREditCostBenefitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.op = nil;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //sender != self.cancelButton &&
    if ([self.titleTextField.text length] > 0) {
        self.op = @"save";
        self.costBenefitTitle = self.titleTextField.text;
    }
}


- (IBAction)saveTapped:(id)sender {
    self.op = @"save";
}
@end
