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
    if (sender != self.saveButton) {
        return;
    }
    if ([self.op isEqualToString:@"insert"]) {
        self.costBenefitItem = [SMRCostBenefitItem createCostBenefitItemInContext:self.context];
    }

    self.costBenefitItem.title = self.titleTextField.text;
    self.costBenefitItem.isAdvantage = [NSNumber numberWithBool:NO];
    self.costBenefitItem.isDoing = [NSNumber numberWithBool:YES];
    self.costBenefitItem.isLongTerm = [NSNumber numberWithBool:YES];
    self.costBenefitItem.costBenefit = self.costBenefit;
    self.costBenefitItem.seq = [NSNumber numberWithInt:10];
    NSLog(@"costBenefitItem %@", self.costBenefitItem);
    if ([self.op isEqualToString:@"insert"]) {
        [self.costBenefit addCostBenefitItemsObject:(NSManagedObject *)self.costBenefitItem];
    }
    NSError *error;
    [self.context save:&error];
}

@end
