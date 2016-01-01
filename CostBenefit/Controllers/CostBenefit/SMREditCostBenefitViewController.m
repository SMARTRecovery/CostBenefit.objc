//
//  SMREditCostBenefitViewController.m
//  CostBenefit
//
//  Created by Aaron Schachter on 12/19/15.
//  Copyright © 2015 smartrecovery.org. All rights reserved.
//

#import "SMREditCostBenefitViewController.h"
#import "SMRCostBenefitViewController.h"

@interface SMREditCostBenefitViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (assign, nonatomic) BOOL isNew;
@property (strong, nonatomic) SMRCostBenefit *costBenefit;
@property (strong, nonatomic) UIBarButtonItem *cancelButton;
@property (strong, nonatomic) UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

- (IBAction)titleTextFieldEditingChanged:(id)sender;

@end

@implementation SMREditCostBenefitViewController

#pragma mark - NSObject

- (instancetype)initWithCostBenefitItem:(SMRCostBenefit *)costBenefit isNew:(BOOL)isNew managedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    self = [super initWithNibName:@"SMREditCostBenefitView" bundle:nil];

    if (self) {
        _costBenefit = costBenefit;
        _isNew = isNew;
        _managedObjectContext = managedObjectContext;
    }

    return self;
}
#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.titleTextField.delegate = self;
    if (self.isNew) {
        self.title = @"New CBA";
        self.costBenefit = [SMRCostBenefit createCostBenefitInContext:self.managedObjectContext];
        self.costBenefit.dateCreated = [[NSDate alloc] init];
        self.costBenefit.type = @"substance";
    }
    else {
        self.title = @"Edit CBA";
        self.titleTextField.text = self.costBenefit.title;
    }
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"rowCell"];

    self.cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped:)];
    self.navigationItem.leftBarButtonItem  = self.cancelButton;
    self.saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveButtonTouchUpInside:)];
    self.navigationItem.rightBarButtonItem = self.saveButton;
    self.saveButton.enabled = NO;
}

#pragma mark - SMREditCostBenefitItemViewController

- (void)cancelButtonTapped:(id)sender {
    [self.managedObjectContext rollback];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveButtonTouchUpInside:(id)sender {
    self.costBenefit.dateUpdated = [[NSDate alloc] init];
    self.costBenefit.title = self.titleTextField.text;
    NSError *error;
    [self.managedObjectContext save:&error];

    UINavigationController *navVC = (UINavigationController *)self.presentingViewController;

    if (!self.isNew) {
        SMRCostBenefitViewController *destVC = (SMRCostBenefitViewController *)navVC.topViewController;
        destVC.managedObjectContext = self.managedObjectContext;
    }
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        if (self.isNew) {
            SMRCostBenefitViewController *destVC = [[SMRCostBenefitViewController alloc] initWithCostBenefit:self.costBenefit managedObjectContext:self.managedObjectContext];
            [navVC pushViewController:destVC animated:YES];
        }
    }];
}

- (IBAction)titleTextFieldEditingChanged:(id)sender {
    if ([self.titleTextField.text length] < 2) {
        self.saveButton.enabled = NO;
    }
    else {
        self.saveButton.enabled = YES;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rowCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (indexPath.row == 0) {
        cell.textLabel.text = @"The substance";
        if ([self.costBenefit.type isEqualToString:@"substance"]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else {
        cell.textLabel.text = @"The activity";
        if ([self.costBenefit.type isEqualToString:@"activity"]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }

    return cell;
}

#pragma mark = UITableViewDelegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        self.costBenefit.type = @"substance";
    }
    else {
        self.costBenefit.type = @"activity";
    }
    if (self.titleTextField.text.length > 2) {
        self.saveButton.enabled = YES;
    }
    [self.tableView reloadData];
}

@end
