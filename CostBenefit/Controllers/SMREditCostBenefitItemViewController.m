//
//  SMREditCostBenefitItemViewController.m
//  CostBenefit
//
//  Created by Aaron Schachter on 11/23/15.
//  Copyright © 2015 smartrecovery.org. All rights reserved.
//

#import "SMREditCostBenefitItemViewController.h"
#import "SMRCostBenefitViewController.h"
#import "MMDrawerController.h"

@interface SMREditCostBenefitItemViewController ()

@property (assign, nonatomic) BOOL isNew;
@property (strong, nonatomic) SMRCostBenefitItem *costBenefitItem;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UILabel *boxDescriptionLabel;
@property (weak, nonatomic) IBOutlet UITextField *costBenefitItemTitleField;

- (IBAction)saveButtonTouchUpInside:(id)sender;

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

    if (self.isNew) {
        self.title = @"Add Item";
    }
    else {
        self.title = @"Edit Item";
        self.costBenefitItemTitleField.text = self.costBenefitItem.title;
    }

    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismiss:)];
    self.navigationItem.rightBarButtonItem = cancelButton;
    SMRCostBenefit *costBenefit = self.costBenefitItem.costBenefit;
    self.boxDescriptionLabel.text = [NSString stringWithFormat:@"%@ %@ is:", [costBenefit getBoxLabelText:self.costBenefitItem.boxNumber isPlural:NO], costBenefit.title.lowercaseString];
}

#pragma mark - SMREditCostBenefitItemViewController

- (void)dismiss:(id)sender {
    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)saveButtonTouchUpInside:(id)sender {
    self.costBenefitItem.title = self.costBenefitItemTitleField.text;
    // Hardcode for now.
    self.costBenefitItem.isLongTerm = [NSNumber numberWithBool:YES];
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

@end
