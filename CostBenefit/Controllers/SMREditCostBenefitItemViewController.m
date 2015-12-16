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
#import "MMDrawerController.h"

@interface SMREditCostBenefitItemViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (assign, nonatomic) BOOL isNew;
@property (strong, nonatomic) SMRCostBenefitItem *costBenefitItem;
@property (strong, nonatomic) UIBarButtonItem *cancelButton;
@property (strong, nonatomic) UIBarButtonItem *saveButton;

@property (weak, nonatomic) IBOutlet UILabel *boxDescriptionLabel;
@property (weak, nonatomic) IBOutlet UITextField *costBenefitItemTitleField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)CostBenefitItemTitleFieldEditingChanged:(id)sender;

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
    [self.tableView registerNib:[UINib nibWithNibName:@"SMRCostBenefitBoxTableViewCell" bundle:nil] forCellReuseIdentifier:@"rowCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    if (self.isNew) {
        self.title = @"Add Item";
    }
    else {
        self.title = @"Edit Item";
        self.costBenefitItemTitleField.text = self.costBenefitItem.title;
    }

    self.cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped:)];
    self.navigationItem.leftBarButtonItem  = self.cancelButton;
    self.saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveButtonTouchUpInside:)];
    self.navigationItem.rightBarButtonItem = self.saveButton;
    self.saveButton.enabled = NO;

    SMRCostBenefit *costBenefit = self.costBenefitItem.costBenefit;
    self.boxDescriptionLabel.text = [NSString stringWithFormat:@"%@ %@ is:", [costBenefit getBoxLabelText:self.costBenefitItem.boxNumber isPlural:NO], costBenefit.title.lowercaseString];
}

#pragma mark - SMREditCostBenefitItemViewController

- (void)cancelButtonTapped:(id)sender {
    [self.managedObjectContext rollback];
    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveButtonTouchUpInside:(id)sender {
    self.costBenefitItem.title = self.costBenefitItemTitleField.text;
    self.costBenefitItem.seq = [NSNumber numberWithInt:10];
    self.costBenefitItem.costBenefit.dateUpdated = [[NSDate alloc] init];
    if (self.isNew) {
        self.costBenefitItem.dateCreated = [[NSDate alloc] init];
        [self.costBenefitItem.costBenefit addCostBenefitItemsObject:(NSManagedObject *)self.costBenefitItem];
    }
    NSError *error;
    [self.managedObjectContext save:&error];
    MMDrawerController *rootVC = (MMDrawerController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    UINavigationController *navVC = (UINavigationController *)rootVC.centerViewController;
    SMRCostBenefitViewController *costBenefitVC = (SMRCostBenefitViewController *)navVC.topViewController;
    costBenefitVC.managedObjectContext = self.managedObjectContext;
    [rootVC dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)CostBenefitItemTitleFieldEditingChanged:(id)sender {
    if ([self.costBenefitItemTitleField.text length] < 2) {
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
    SMRCostBenefitBoxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rowCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.titleLabelText = @"Long-term";
        if ([self.costBenefitItem.isLongTerm boolValue]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else {
        cell.titleLabelText = @"Short-term";
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
    self.saveButton.enabled = YES;
    [self.tableView reloadData];
}

@end
