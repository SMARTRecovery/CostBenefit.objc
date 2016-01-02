//
//  SMREditCostBenefitItemViewController.m
//  CostBenefit
//
//  Created by Aaron Schachter on 11/23/15.
//  Copyright © 2015 smartrecovery.org. All rights reserved.
//

#import "SMREditCostBenefitItemViewController.h"
#import "SMRCostBenefitViewController.h"
#import "SMRCostBenefitBoxTableViewCell.h"

@interface SMREditCostBenefitItemViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (assign, nonatomic) BOOL isNew;
@property (strong, nonatomic) SMRCostBenefitItem *costBenefitItem;
@property (strong, nonatomic) UIBarButtonItem *cancelButton;
@property (strong, nonatomic) UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) IBOutlet UILabel *boxDescriptionLabel;
@property (weak, nonatomic) IBOutlet UITextField *costBenefitItemTitleField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)CostBenefitItemTitleFieldEditingChanged:(id)sender;
- (IBAction)deleteButtonTouchUpInside:(id)sender;


@end

@implementation SMREditCostBenefitItemViewController

#pragma mark - NSObject

- (instancetype)initWithCostBenefitItem:(SMRCostBenefitItem *)costBenefitItem isNew:(BOOL)isNew managedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    self = [super initWithNibName:@"SMREditCostBenefitItemView" bundle:nil];

    if (self) {
        _costBenefitItem = costBenefitItem;
        _isNew = isNew;
        _managedObjectContext = managedObjectContext;
    }

    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.costBenefitItemTitleField.delegate = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"rowCell"];
    self.tableView.backgroundColor = nil;

    if (self.isNew) {
        self.title = @"New Item";
        self.deleteButton.hidden = YES;
    }
    else {
        self.title = @"Edit Item";
        self.costBenefitItemTitleField.text = self.costBenefitItem.title;
        self.deleteButton.hidden = NO;
    }

    self.cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped:)];
    self.navigationItem.leftBarButtonItem  = self.cancelButton;
    self.saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveButtonTouchUpInside:)];
    self.navigationItem.rightBarButtonItem = self.saveButton;
    self.saveButton.enabled = NO;

    SMRCostBenefit *costBenefit = self.costBenefitItem.costBenefit;
    self.boxDescriptionLabel.text = [NSString stringWithFormat:@"%@ is:", [costBenefit getBoxLabelText:self.costBenefitItem.boxNumber isPlural:NO]].uppercaseString;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (self.isNew) {
        [self.costBenefitItemTitleField becomeFirstResponder];
    }
}

#pragma mark - SMREditCostBenefitItemViewController

- (void)cancelButtonTapped:(id)sender {
    [self.managedObjectContext rollback];
    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveButtonTouchUpInside:(id)sender {
    self.costBenefitItem.title = [self.costBenefitItemTitleField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    // @todo: This should be calculated to go to the end... or first
    self.costBenefitItem.seq = [NSNumber numberWithInt:10];
    self.costBenefitItem.costBenefit.dateUpdated = [[NSDate alloc] init];
    if (self.isNew) {
        self.costBenefitItem.dateCreated = [[NSDate alloc] init];
        [self.costBenefitItem.costBenefit addCostBenefitItemsObject:(NSManagedObject *)self.costBenefitItem];
    }
    NSError *error;
    [self.managedObjectContext save:&error];

    if ([self.presentingViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navVC = (UINavigationController *)self.presentingViewController;
        // @todo sanity check topViewController isKindOfClass
        SMRCostBenefitViewController *costBenefitVC = (SMRCostBenefitViewController *)navVC.topViewController;
        costBenefitVC.managedObjectContext = self.managedObjectContext;
    }
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)CostBenefitItemTitleFieldEditingChanged:(id)sender {
    if ([self.costBenefitItemTitleField.text length] < 2) {
        self.saveButton.enabled = NO;
    }
    else {
        self.saveButton.enabled = YES;
    }
}

- (IBAction)deleteButtonTouchUpInside:(id)sender {
    UIAlertController *confirmDeleteAlertController = [UIAlertController alertControllerWithTitle:@"Are you sure you want to delete this item?" message:@"This cannot be undone." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        [self.costBenefitItem.costBenefit setDateCreated:[[NSDate alloc] init]];
        [self.costBenefitItem.costBenefit removeCostBenefitItemsObject:self.costBenefitItem];
        [self.managedObjectContext deleteObject:self.costBenefitItem];
        NSError *error;
        [self.managedObjectContext save:&error];
        UINavigationController *presentingVC = (UINavigationController *)self.presentingViewController;
        SMRCostBenefitViewController *destVC = (SMRCostBenefitViewController *)presentingVC.topViewController;
        destVC.managedObjectContext = self.managedObjectContext;
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
    }];
    [confirmDeleteAlertController addAction:deleteAction];
    [confirmDeleteAlertController addAction:cancelAction];

     [self presentViewController:confirmDeleteAlertController animated:YES completion:nil];
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
    cell.textLabel.font = [UIFont systemFontOfSize:13.0];
    cell.textLabel.textColor = UIColor.darkGrayColor;

    if (indexPath.row == 0) {
        cell.textLabel.text = @"Long-term".uppercaseString;
        if ([self.costBenefitItem.isLongTerm boolValue]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else {
        cell.textLabel.text = @"Short-term".uppercaseString;
        if ([self.costBenefitItem.isLongTerm boolValue]) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        self.costBenefitItem.isLongTerm = [NSNumber numberWithBool:YES];
    }
    else {
        self.costBenefitItem.isLongTerm = [NSNumber numberWithBool:NO];
    }
    if (self.costBenefitItemTitleField.text.length > 2) {
        self.saveButton.enabled = YES;
    }
    [self.tableView reloadData];
}

@end
