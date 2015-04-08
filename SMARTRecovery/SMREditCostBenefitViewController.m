//
//  SMREditCostBenefitViewController.m
//  SMARTRecovery
//
//  Created by Aaron Schachter on 3/30/15.
//  Copyright (c) 2015 smartrecovery.org. All rights reserved.
//

#import "SMREditCostBenefitViewController.h"

@interface SMREditCostBenefitViewController ()
@property (strong, nonatomic) NSArray *typeOptions;
@property (weak, nonatomic) IBOutlet UIPickerView *typePicker;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
- (IBAction)saveTapped:(id)sender;

@end

@implementation SMREditCostBenefitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.typePicker.dataSource = self;
    self.typePicker.delegate = self;
    _typeOptions = @[@"The substance", @"The activity"];
    if (self.costBenefit != nil) {
        self.title = @"Edit CBA";
        self.titleTextField.text = self.costBenefit.title;
    }
    else {
        self.costBenefit = [SMRCostBenefit createCostBenefitInContext:self.context];
        self.title = @"New CBA";
        self.costBenefit.type = @"substance";
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([self.costBenefit.type isEqualToString:@"activity"]) {
        [self.typePicker selectRow:1 inComponent:0 animated:YES];
        [self.typePicker reloadComponent:0];
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


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (sender == self.cancelButton) {
        return;
    }
    self.costBenefit.title = self.titleTextField.text;
    if ([self.typePicker selectedRowInComponent:0] == 0) {
        self.costBenefit.type = @"substance";
    }
    else {
        self.costBenefit.type = @"activity";
    }
    NSError *error;
    [self.context save:&error];
}


- (IBAction)saveTapped:(id)sender {
    // @todo: if inserted, load new CostBenefit, else redirect to view CostBenefit
}
@end
