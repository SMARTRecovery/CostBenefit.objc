//
//  SMREditCostBenefitViewController.m
//  CostBenefit
//
//  Created by Aaron Schachter on 12/19/15.
//  Copyright © 2015 smartrecovery.org. All rights reserved.
//

#import "SMREditCostBenefitViewController.h"

@interface SMREditCostBenefitViewController ()

@property (assign, nonatomic) BOOL isNew;
@property (strong, nonatomic) SMRCostBenefit *costBenefit;
@property (strong, nonatomic) UIBarButtonItem *cancelButton;
@property (strong, nonatomic) UIBarButtonItem *saveButton;

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

@end

@implementation SMREditCostBenefitViewController

#pragma mark - NSObject

- (instancetype)initWithCostBenefitItem:(SMRCostBenefit *)costBenefit isNew:(BOOL)isNew managedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    self = [super initWithNibName:@"SMREditCostBenefitItemView" bundle:nil];

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

    self.cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped:)];
    self.navigationItem.leftBarButtonItem  = self.cancelButton;
    self.saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveButtonTouchUpInside:)];
    self.navigationItem.rightBarButtonItem = self.saveButton;
    self.saveButton.enabled = NO;
}

#pragma mark - SMREditCostBenefitItemViewController

- (void)cancelButtonTapped:(id)sender {
    [self.managedObjectContext rollback];
    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveButtonTouchUpInside:(id)sender {
    self.costBenefit.dateCreated = [[NSDate alloc] init];
    self.costBenefit.dateUpdated = [[NSDate alloc] init];
    self.costBenefit.title = self.titleTextField.text;
    // Hardcode for now
    self.costBenefit.type = @"substance";
    NSError *error;
    [self.managedObjectContext save:&error];
    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] dismissViewControllerAnimated:YES completion:nil];
}

@end
