//
//  SMRCostBenefitItemViewController.m
//  SMARTRecovery
//
//  Created by Aaron Schachter on 4/1/15.
//  Copyright (c) 2015 smartrecovery.org. All rights reserved.
//

#import "SMRCostBenefitItemViewController.h"
#import "SMRCostBenefitItem+methods.h"

@interface SMRCostBenefitItemViewController ()

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@end

@implementation SMRCostBenefitItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.costBenefitItem != nil) {
        self.titleTextField.text = self.costBenefitItem.title;
    }
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SMRCostBenefitItem *costBenefitItem = [SMRCostBenefitItem createCostBenefitItemInContext:self.context];
    costBenefitItem.title = self.titleTextField.text;
    costBenefitItem.isAdvantage = [NSNumber numberWithBool:NO];
    costBenefitItem.isDoing = [NSNumber numberWithBool:YES];
    costBenefitItem.isLongTerm = [NSNumber numberWithBool:YES];
    costBenefitItem.costBenefit = self.costBenefit;
    costBenefitItem.seq = [NSNumber numberWithInt:10];
    NSLog(@"costBenefitItem %@", costBenefitItem);

    [self.costBenefit addCostBenefitItemsObject:(NSManagedObject *)costBenefitItem];
    NSError *error;
    [self.context save:&error];
}

@end
