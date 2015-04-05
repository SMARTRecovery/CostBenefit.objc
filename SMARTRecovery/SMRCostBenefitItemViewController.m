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
@property (weak, nonatomic) IBOutlet UILabel *longTermLabel;
@property (weak, nonatomic) IBOutlet UISwitch *longTermSwitch;

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *trashButton;

- (IBAction)trashTapped:(id)sender;
@end

@implementation SMRCostBenefitItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.longTermLabel.text = @"Long-term advantage";
    if (self.costBenefitItem != nil) {
        self.titleTextField.text = self.costBenefitItem.title;
        self.longTermSwitch.on = [self.costBenefitItem.isLongTerm boolValue];
    }
    else {
        self.trashButton.enabled = NO;
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
    // Hardcode box # for now.
    self.costBenefitItem.boxNumber = [NSNumber numberWithInt:0];
    self.costBenefitItem.isLongTerm = [NSNumber numberWithBool:self.longTermSwitch.isOn];
    self.costBenefitItem.costBenefit = self.costBenefit;
    self.costBenefitItem.seq = [NSNumber numberWithInt:10];

    if ([self.op isEqualToString:@"insert"]) {
        [self.costBenefit addCostBenefitItemsObject:(NSManagedObject *)self.costBenefitItem];
    }
    NSError *error;
    [self.context save:&error];
}

- (IBAction)trashTapped:(id)sender {
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:@"Delete item?"
                                 message:@"This cannot be undone."
                                 preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Delete"
                         style:UIAlertActionStyleDestructive
                         handler:^(UIAlertAction * action)
                         {
                             [view dismissViewControllerAnimated:YES completion:nil];
                             [self.costBenefit removeCostBenefitItemsObject:(NSManagedObject *)self.costBenefitItem];
                             [self.context deleteObject:self.costBenefitItem];
                             [self performSegueWithIdentifier:@"segueToCostBenefit" sender:self];
                             NSError *error;
                             [self.context save:&error];
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [view dismissViewControllerAnimated:YES completion:nil];

                             }];


    [view addAction:ok];
    [view addAction:cancel];
    [self presentViewController:view animated:YES completion:nil];
}
@end
