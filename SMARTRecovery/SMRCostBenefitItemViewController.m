//
//  SMRCostBenefitItemViewController.m
//  SMARTRecovery
//
//  Created by Aaron Schachter on 4/1/15.
//  Copyright (c) 2015 smartrecovery.org. All rights reserved.
//

#import "SMRCostBenefitItemViewController.h"
#import "SMRCostBenefitItem+methods.h"
#import "SMRViewControllerHelper.h"

@interface SMRCostBenefitItemViewController ()
@property (strong, nonatomic) NSArray *boxOptions;
@property (weak, nonatomic) IBOutlet UIPickerView *boxPicker;
@property (weak, nonatomic) IBOutlet UILabel *longTermLabel;
@property (weak, nonatomic) IBOutlet UISwitch *longTermSwitch;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

- (IBAction)cancelTapped:(id)sender;
- (IBAction)saveTapped:(id)sender;
- (IBAction)trashTapped:(id)sender;
@end

@implementation SMRCostBenefitItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.boxPicker.dataSource = self;
    self.boxPicker.delegate = self;
    _boxOptions =  @[@[@"Advantage", @"Disadvantage"],
                     @[@"of doing", @"of not doing"]];
    self.longTermLabel.text = @"Long-term advantage";
    if (self.costBenefitItem != nil) {
        self.titleTextField.text = self.costBenefitItem.title;
        self.longTermSwitch.on = [self.costBenefitItem.isLongTerm boolValue];
        self.title = @"Edit Item";
    }
    else {
        self.navigationController.toolbarHidden = YES;
        self.saveButton.enabled = NO;
        self.costBenefitItem = [SMRCostBenefitItem createCostBenefitItemInContext:self.context];
        // Set to Box 0 as default.
        self.costBenefitItem.boxNumber = [NSNumber numberWithInt:0];
        self.title = @"Add Item";
    }
    [self.titleTextField addTarget:self
                            action:@selector(editingChanged:)
                  forControlEvents:UIControlEventEditingChanged];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    switch ([self.costBenefitItem.boxNumber intValue]) {
        case 1:
            [self.boxPicker selectRow:1 inComponent:0 animated:YES];
            [self.boxPicker reloadComponent:0];
            self.longTermLabel.text = @"Long-term disadvantage";
            break;
        case 2:
            [self.boxPicker selectRow:1 inComponent:1 animated:YES];
            [self.boxPicker reloadComponent:1];
            break;
        case 3:
            [self.boxPicker selectRow:1 inComponent:0 animated:YES];
            [self.boxPicker reloadComponent:0];
            [self.boxPicker selectRow:1 inComponent:1 animated:YES];
            [self.boxPicker reloadComponent:1];
            self.longTermLabel.text = @"Long-term disadvantage";
            break;
        default:
            break;
    }
}

-(void) editingChanged:(id)sender {
    self.saveButton.enabled = YES;
    if ([self.titleTextField.text length] < 3) {
        self.saveButton.enabled = NO;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        if (row == 0) {
            self.longTermLabel.text = @"Long-term advantage";
        }
        else {
            self.longTermLabel.text = @"Long-term disadvantage";
        }
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _boxOptions.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _boxOptions[component][row];
}

- (void)save {
    self.costBenefitItem.title = self.titleTextField.text;
    self.costBenefitItem.isLongTerm = [NSNumber numberWithBool:self.longTermSwitch.isOn];
    self.costBenefitItem.costBenefit = self.costBenefit;

    // Harcoded for now.
    self.costBenefitItem.seq = [NSNumber numberWithInt:10];

    // Calculate boxNumber.
    // If advantage is selected:
    if ([self.boxPicker selectedRowInComponent:0] == 0) {
        // Advantage of doing:
        if ([self.boxPicker selectedRowInComponent:1] == 0) {
            self.costBenefitItem.boxNumber = [NSNumber numberWithInt:0];
        }
        // Advantage of not doing:
        else {
            self.costBenefitItem.boxNumber = [NSNumber numberWithInt:2];
        }
    }
    // Else disadvantage is selected:
    else {
        // Disadvantage of doing:
        if ([self.boxPicker selectedRowInComponent:1] == 0) {
            self.costBenefitItem.boxNumber = [NSNumber numberWithInt:1];
        }
        // Disadvantage of not doing:
        else {
            self.costBenefitItem.boxNumber = [NSNumber numberWithInt:3];
        }
    }
    if ([self.op isEqualToString:@"insert"]) {
        [self.costBenefit addCostBenefitItemsObject:(NSManagedObject *)self.costBenefitItem];
    }
    NSError *error;
    [self.context save:&error];
}

- (IBAction)cancelTapped:(id)sender {
    [SMRViewControllerHelper presentCostBenefit:self.costBenefit viewController:self context:self.context];
}

- (IBAction)saveTapped:(id)sender {
    [self save];
    [SMRViewControllerHelper presentCostBenefit:self.costBenefit viewController:self context:self.context];
}

- (IBAction)trashTapped:(id)sender {
    UIAlertController* view=   [UIAlertController
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
                             [SMRViewControllerHelper presentCostBenefit:self.costBenefit viewController:self context:self.context];
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
