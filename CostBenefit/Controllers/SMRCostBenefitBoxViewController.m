//
//  SMRCostBenefitBoxViewController.m
//  CostBenefit
//
//  Created by Aaron Schachter on 11/21/15.
//  Copyright © 2015 smartrecovery.org. All rights reserved.
//

#import "SMRCostBenefitBoxViewController.h"
#import "SMRCostBenefitItem+methods.h"
#import "SMRCostBenefitBoxTableViewCell.h"
#import "SMREditCostBenefitItemViewController.h"

@interface SMRCostBenefitBoxViewController () <UITableViewDataSource, UITableViewDelegate>

@property (assign, nonatomic) BOOL didEditBox;
@property (strong, nonatomic, readwrite) NSNumber *boxNumber;
@property (strong, nonatomic, readwrite) SMRCostBenefit *costBenefit;

@property (weak, nonatomic) IBOutlet UILabel *boxHeaderLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addItemButton;
@property (weak, nonatomic) IBOutlet UIButton *editBoxButton;

- (IBAction)addItemButtonTouchUpInside:(id)sender;
- (IBAction)editBoxButtonTouchUpInside:(id)sender;
@end

@implementation SMRCostBenefitBoxViewController

#pragma mark - NSObject

- (instancetype)initWithCostBenefitViewController:(SMRCostBenefitViewController *)costBenefitViewController boxNumber:(NSNumber *)boxNumber managedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    self = [super initWithNibName:@"SMRCostBenefitBoxView" bundle:nil];

    if (self) {
        _costBenefitViewController = costBenefitViewController;
        _costBenefit = costBenefitViewController.costBenefit;
        _boxNumber = boxNumber;
        _managedObjectContext = managedObjectContext;
    }

    return self;

}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerNib:[UINib nibWithNibName:@"SMRCostBenefitBoxTableViewCell" bundle:nil] forCellReuseIdentifier:@"rowCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.0];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 66;

    self.costBenefitItems = [self.costBenefit loadItemsForBoxNumber:self.boxNumber managedObjectContext:self.managedObjectContext];

    self.boxHeaderLabel.text = [self.costBenefit getBoxLabelText:self.boxNumber isPlural:YES];
    self.didEditBox = NO;
    self.tableView.editing = NO;
    self.editBoxButton.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (self.costBenefitItems.count == 0) {
        self.editBoxButton.hidden = YES;
    }
    else {
        self.editBoxButton.hidden = NO;
    }
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    if (self.tableView.editing) {
        [self finishEditing];
    }
}

#pragma mark - SMRCostBenefitBoxViewController

- (void)reloadData {
    self.costBenefitItems = [self.costBenefit loadItemsForBoxNumber:self.boxNumber managedObjectContext:self.managedObjectContext];
    [self.tableView reloadData];
}

- (IBAction)addItemButtonTouchUpInside:(id)sender {
    SMRCostBenefitItem *costBenefitItem = [SMRCostBenefitItem createCostBenefitItemInContext:self.managedObjectContext];
    costBenefitItem.boxNumber = self.boxNumber;
    costBenefitItem.costBenefit = self.costBenefit;
    costBenefitItem.isLongTerm = [NSNumber numberWithBool:YES];
    SMREditCostBenefitItemViewController *addItemVC = [[SMREditCostBenefitItemViewController alloc] initWithCostBenefitItem:costBenefitItem isNew:YES managedObjectContext:self.managedObjectContext];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:addItemVC];
    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:navVC animated:YES completion:nil];
}

- (IBAction)editBoxButtonTouchUpInside:(id)sender {
    if (!self.tableView.editing) {
        [self.tableView setEditing:YES animated:YES];
        [self.editBoxButton setTitle:@"Done" forState:UIControlStateNormal];
        self.addItemButton.hidden = YES;
    }
    else {
        [self finishEditing];
    }
}

- (void)finishEditing {
  if (self.didEditBox) {
        for (int i = 0; i < self.costBenefitItems.count; i++) {
            NSIndexPath *indexPath =[NSIndexPath indexPathForRow:i inSection:0];
            SMRCostBenefitBoxTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.costBenefitItem.seq = [NSNumber numberWithInt:i];
        }
        NSError *error;
        [self.managedObjectContext save:&error];
    }
    [self.tableView setEditing:NO animated:YES];
    [self.editBoxButton setTitle:@"Edit" forState:UIControlStateNormal];
    self.addItemButton.hidden = NO;
    self.didEditBox = NO;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.costBenefitItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SMRCostBenefitBoxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rowCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SMRCostBenefitItem *costBenefitItem = (SMRCostBenefitItem *)self.costBenefitItems[indexPath.row];
    cell.costBenefitItem = costBenefitItem;
    cell.titleLabelText = costBenefitItem.title;
    if ([costBenefitItem.isLongTerm boolValue]) {
        cell.longTermLabelText = @"Long-term".uppercaseString;
    }
    else {
        cell.longTermLabelText = @"Short-term".uppercaseString;
    }

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        self.didEditBox = YES;
        SMRCostBenefitItem *costBenefitItem = (SMRCostBenefitItem *)self.costBenefitItems[indexPath.row];
        [self.costBenefit removeCostBenefitItemsObject:(NSManagedObject *)costBenefitItem];
        [self.managedObjectContext deleteObject:costBenefitItem];
        [self.costBenefit setDateUpdated:[[NSDate alloc] init]];
        NSError *error;
        [self.managedObjectContext save:&error];
        self.costBenefitItems = [self.costBenefit loadItemsForBoxNumber:self.boxNumber managedObjectContext:self.managedObjectContext];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    self.didEditBox = YES;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SMRCostBenefitItem *costBenefitItem = (SMRCostBenefitItem *)self.costBenefitItems[indexPath.row];
    SMREditCostBenefitItemViewController *destVC = [[SMREditCostBenefitItemViewController alloc] initWithCostBenefitItem:costBenefitItem isNew:NO managedObjectContext:self.managedObjectContext];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:destVC];
    // Fixes weird delay - http://stackoverflow.com/a/28215125/1470725
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:navVC animated:YES completion:nil];
    });
}

@end
