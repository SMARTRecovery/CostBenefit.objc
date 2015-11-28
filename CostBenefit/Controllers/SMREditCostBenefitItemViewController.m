//
//  SMREditCostBenefitItemViewController.m
//  CostBenefit
//
//  Created by Aaron Schachter on 11/23/15.
//  Copyright © 2015 smartrecovery.org. All rights reserved.
//

#import "SMREditCostBenefitItemViewController.h"

@interface SMREditCostBenefitItemViewController ()

@property (strong, nonatomic) SMRCostBenefitItem *costBenefitItem;

@property (weak, nonatomic) IBOutlet UILabel *boxDescriptionLabel;
@property (weak, nonatomic) IBOutlet UITextField *costBenefitItemTitleField;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end

@implementation SMREditCostBenefitItemViewController

#pragma mark - NSObject

- (instancetype)initWithCostBenefitItem:(SMRCostBenefitItem *)costBenefitItem managedObjectContext:(NSManagedObjectContext *)managedObjectContext{
    self = [super initWithNibName:@"SMREditCostBenefitView" bundle:nil];

    if (self) {
        _costBenefitItem = costBenefitItem;
        _managedObjectContext = managedObjectContext;
    }

    return self;
    
}
#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Add Item";
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismiss:)];
    self.navigationItem.rightBarButtonItem = cancelButton;
    SMRCostBenefit *costBenefit = self.costBenefitItem.costBenefit;
    self.boxDescriptionLabel.text = [costBenefit getBoxLabelText:self.costBenefitItem.boxNumber isPlural:NO];
    NSLog(@"costBenefit %@", costBenefit.title);
    self.boxDescriptionLabel.text = @"testing";
}

#pragma mark - SMREditCostBenefitItemViewController

- (void)dismiss:(id)sender {
    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] dismissViewControllerAnimated:YES completion:nil];
}

@end
