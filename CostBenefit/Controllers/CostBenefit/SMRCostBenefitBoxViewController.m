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

    self.boxHeaderLabel.text = [self.costBenefit getBoxLabelText:self.boxNumber isPlural:YES].uppercaseString;
    self.didEditBox = NO;
    self.tableView.editing = NO;
    self.editBoxButton.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (self.costBenefitItems.count < 2) {
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
    self.boxHeaderLabel.text = [self.costBenefit getBoxLabelText:self.boxNumber isPlural:YES].uppercaseString;
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
    navVC.navigationBar.translucent = NO;
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

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    self.didEditBox = YES;
}

- (UIView *)tableView:(UITableView *)tableView
viewForFooterInSection:(NSInteger)section {
    if (self.costBenefitItems.count > 0) {
        return nil;
    }
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width - 16, 144)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = UIColor.grayColor;
    titleLabel.numberOfLines = 0;
    UILabel *copyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 144, tableView.frame.size.width - 16, 144)];
    copyLabel.numberOfLines = 0;
    copyLabel.font = [UIFont systemFontOfSize:14];
    switch ([self.boxNumber intValue]) {
        case 0:
            titleLabel.text = @"What do I enjoy about my addiction?";
            copyLabel.text = @"List as many specific things as you can that you liked about whatever you are/were addicted to.";
            break;
        case 1:
            titleLabel.text = @"What do I hate about my addiction?";
            copyLabel.text = @"List as many specific examples of the bad, undesirable results of your addiction as you can.";
            break;
        case 2:
            titleLabel.text = @"What will I like about giving up my addiction?";
            copyLabel.text = @"List what good things you think/fantasize will happen when you stop your addiction.";
            break;
        case 3:
            titleLabel.text = @"What won't I like about giving up my addiction?";
            copyLabel.text = @"List what you think you are going to hate, dread or merely dislike about living without your addiction.";
            break;
    }
    [footerView addSubview:titleLabel];
    [footerView addSubview:copyLabel];

    return footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.costBenefitItems.count > 0) {
        return 0;
    }
    return 200;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SMRCostBenefitItem *costBenefitItem = (SMRCostBenefitItem *)self.costBenefitItems[indexPath.row];
    SMREditCostBenefitItemViewController *destVC = [[SMREditCostBenefitItemViewController alloc] initWithCostBenefitItem:costBenefitItem isNew:NO managedObjectContext:self.managedObjectContext];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:destVC];
    navVC.navigationBar.translucent = NO;
    // Fixes weird delay - http://stackoverflow.com/a/28215125/1470725
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:navVC animated:YES completion:nil];
    });
}

@end
