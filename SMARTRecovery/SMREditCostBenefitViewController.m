//
//  SMREditCostBenefitViewController.m
//  SMARTRecovery
//
//  Created by Aaron Schachter on 3/30/15.
//  Copyright (c) 2015 smartrecovery.org. All rights reserved.
//

#import "SMREditCostBenefitViewController.h"
#import "SMRListCostBenefitsViewController.h"
#import "SMRCostBenefitViewController.h"
#import "SMRCostBenefitItemViewController.h"
#import "SMRViewControllerHelper.h"

@interface SMREditCostBenefitViewController ()

@property (strong, nonatomic) NSArray *typeOptions;
@property (strong, nonatomic) NSString *descActivity;
@property (strong, nonatomic) NSString *descSubstance;
@property (strong, nonatomic) NSString *op;
@property (strong, nonatomic) NSString *placeholderActivity;
@property (strong, nonatomic) NSString *placeholderSubstance;

@property (weak, nonatomic) IBOutlet UIPickerView *typePicker;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UILabel *titleDescLabel;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

- (IBAction)cancelTapped:(id)sender;
- (IBAction)saveTapped:(id)sender;
- (IBAction)trashTapped:(id)sender;

@end

@implementation SMREditCostBenefitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.typePicker.dataSource = self;
    self.typePicker.delegate = self;
    _typeOptions = @[@"The substance", @"The activity"];

    // Activity help text:
    _descActivity = @"e.g. Procrastinating, gambling, over-eating, etc.";
    _placeholderActivity = @"Activity name";

    // Substance help text:
    _descSubstance = @"e.g. Alcohol, nicotine, sugar, etc.";
    _placeholderSubstance = @"Substance name";

    if (self.costBenefit != nil) {
        self.op = @"update";
        self.title = @"Edit CBA";
        self.titleTextField.text = self.costBenefit.title;
    }
    else {
        self.op = @"insert";
        self.costBenefit = [SMRCostBenefit createCostBenefitInContext:self.context];
        self.title = @"New CBA";
        self.costBenefit.type = @"substance";
        self.navigationController.toolbarHidden = YES;
    }
    [self setHelpText:self.costBenefit.type];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([self.costBenefit.type isEqualToString:@"activity"]) {
        [self.typePicker selectRow:1 inComponent:0 animated:YES];
        [self.typePicker reloadComponent:0];
    }
}

- (void)setHelpText:(NSString *)type {
    if ([type isEqualToString:@"activity"]) {
        self.titleTextField.placeholder = self.placeholderActivity;
        self.titleDescLabel.text = self.descActivity;
    }
    else {
        self.titleTextField.placeholder = self.placeholderSubstance;
        self.titleDescLabel.text = self.descSubstance;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (row == 0) {
        self.costBenefit.type = @"substance";
        [self setHelpText:@"substance"];
    }
    else {
        self.costBenefit.type = @"activity";
        [self setHelpText:@"activity"];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _typeOptions.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return _typeOptions[row];
}

- (IBAction)cancelTapped:(id)sender {
    // If new CostBenefit:
    if ([self.op isEqualToString:@"insert"]) {

        // Delete the newly created CostBenefit.
        [self.context deleteObject:self.costBenefit];

        // Redirect to home screen.
        [SMRViewControllerHelper presentHome:self context:self.context];
    }
    // Else redirect to CostBenefit VC.
    else {
        [SMRViewControllerHelper presentCostBenefit:self.costBenefit viewController:self context:self.context];
    }
}

- (IBAction)saveTapped:(id)sender {
    self.costBenefit.title = self.titleTextField.text;
    NSError *error;
    [self.context save:&error];

    // If new CostBenefit:
    if ([self.op isEqualToString:@"insert"]) {
        // Redirect to the CostBenefitItem Nav VC to create new item.
        UINavigationController *destNavVC = [self.storyboard instantiateViewControllerWithIdentifier:@"costBenefitItemNavigationController"];
        SMRCostBenefitItemViewController *destVC = (SMRCostBenefitItemViewController *)destNavVC.topViewController;
        destVC.context = self.context;
        destVC.costBenefit = self.costBenefit;
        [self presentViewController:destNavVC animated:YES completion:nil];
    }
    // Else redirect to CostBenefit VC.
    else {
        [SMRViewControllerHelper presentCostBenefit:self.costBenefit viewController:self context:self.context];
    }

}

- (IBAction)trashTapped:(id)sender {
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:@"Delete this CBA?"
                                 message:@"All items will be deleted as well. This cannot be undone."
                                 preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Delete"
                         style:UIAlertActionStyleDestructive
                         handler:^(UIAlertAction * action)
                         {
                             [view dismissViewControllerAnimated:YES completion:nil];
                             [self.context deleteObject:self.costBenefit];
                             [SMRViewControllerHelper presentHome:self context:self.context];
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
