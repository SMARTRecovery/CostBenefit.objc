//
//  SMREditCostBenefitViewController.m
//  SMARTRecovery
//
//  Created by Aaron Schachter on 3/30/15.
//  Copyright (c) 2015 smartrecovery.org. All rights reserved.
//

#import "SMREditCostBenefitViewControllerOld.h"
#import "SMRLeftMenuViewController.h"
#import "SMRCostBenefitTableViewController.h"
#import "SMRCostBenefitItemViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"

@interface SMREditCostBenefitViewControllerOld ()

@property (strong, nonatomic) NSArray *typeOptions;
@property (strong, nonatomic) NSString *costBenefitType;
@property (strong, nonatomic) NSString *descActivity;
@property (strong, nonatomic) NSString *descSubstance;
@property (strong, nonatomic) NSString *op;
@property (strong, nonatomic) NSString *placeholderActivity;
@property (strong, nonatomic) NSString *placeholderSubstance;

@property (weak, nonatomic) IBOutlet UIPickerView *typePicker;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UILabel *titleDescLabel;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

- (IBAction)trashTapped:(id)sender;

@end

@implementation SMREditCostBenefitViewControllerOld

- (void)viewDidLoad {
    [super viewDidLoad];

    self.typePicker.dataSource = self;
    self.typePicker.delegate = self;
    self.titleTextField.delegate = self;

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
        self.costBenefitType = self.costBenefit.type;
    }
    else {
        self.saveButton.enabled = NO;
        self.op = @"insert";
        self.title = @"New CBA";
        self.costBenefitType = @"substance";
        self.navigationController.toolbarHidden = YES;
        MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
        [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
    }
    [self setHelpText:self.costBenefitType];
    [self.titleTextField addTarget:self action:@selector(editingChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    if ([self.costBenefit.type isEqualToString:@"activity"]) {
        [self.typePicker selectRow:1 inComponent:0 animated:YES];
        [self.typePicker reloadComponent:0];
    }
}

- (void)editingChanged:(id)sender {
    self.saveButton.enabled = YES;
    if ([self.titleTextField.text length] < 3) {
        self.saveButton.enabled = NO;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
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

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (row == 0) {
        self.costBenefitType = @"substance";
    }
    else {
        self.costBenefitType = @"activity";

    }
    [self setHelpText:self.costBenefitType];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _typeOptions.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _typeOptions[row];
}

- (void)saveCostBenefit {
    NSDate *currentDate = [[NSDate alloc] init];
    if ([self.op isEqualToString:@"insert"]) {
        self.costBenefit = [SMRCostBenefit createCostBenefitInContext:self.context];
        self.costBenefit.dateCreated = currentDate;
    }
    self.costBenefit.title = self.titleTextField.text;
    self.costBenefit.type = self.costBenefitType;
    self.costBenefit.dateUpdated = currentDate;
    NSError *error;
    [self.context save:&error];
}

- (IBAction)trashTapped:(id)sender {
    UIAlertController *view = [UIAlertController alertControllerWithTitle:@"Delete this CBA?" message:@"All items will be deleted as well. This cannot be undone." preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        [view dismissViewControllerAnimated:YES completion:nil];
        [self.context deleteObject:self.costBenefit];
        NSError *error;
        [self.context save:&error];
        [self performSegueWithIdentifier:@"segueToDrawer" sender:self];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [view dismissViewControllerAnimated:YES completion:nil];
    }];

    [view addAction:ok];
    [view addAction:cancel];
    [self presentViewController:view animated:YES completion:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MMDrawerController *drawerController = (MMDrawerController *)[segue destinationViewController];
    [drawerController setShowsShadow:YES];
    [drawerController setShadowRadius:0.9];

    UINavigationController *leftNavVC = [self.storyboard instantiateViewControllerWithIdentifier:@"leftMenuNavigationController"];
    SMRLeftMenuViewController *leftVC = (SMRLeftMenuViewController *)leftNavVC.topViewController;
    [leftVC setContext:self.context];
    [drawerController setLeftDrawerViewController:leftNavVC];

    if ([sender isEqual:self.saveButton]) {
        [self saveCostBenefit];
        UINavigationController *costBenefitNavVC = [self.storyboard instantiateViewControllerWithIdentifier:@"costBenefitNavigationController"];
        SMRCostBenefitTableViewController *costBenefitVC = ( SMRCostBenefitTableViewController *)costBenefitNavVC.topViewController;
        [costBenefitVC setCostBenefit:self.costBenefit];
        [costBenefitVC setContext:self.context];
        [drawerController setCenterViewController:costBenefitNavVC withCloseAnimation:YES completion:nil];
    }
    else {
        UINavigationController *centerNavVC = [self.storyboard instantiateViewControllerWithIdentifier:@"editCostBenefitNavVC"];
        SMREditCostBenefitViewControllerOld *centerVC = (SMREditCostBenefitViewControllerOld *)centerNavVC.topViewController;
        [centerVC setContext:self.context];
        [drawerController setCenterViewController:centerNavVC withCloseAnimation:YES completion:nil];
    }
}

#pragma mark - Button Handlers

-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

@end
