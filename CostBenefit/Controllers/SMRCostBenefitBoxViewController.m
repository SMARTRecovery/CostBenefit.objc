//
//  SMRCostBenefitBoxViewController.m
//  CostBenefit
//
//  Created by Aaron Schachter on 11/21/15.
//  Copyright © 2015 smartrecovery.org. All rights reserved.
//

#import "SMRCostBenefitBoxViewController.h"
#import "SMRCostBenefitItem+methods.h"
#import "SMREditCostBenefitItemViewController.h"

@interface SMRCostBenefitBoxViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic, readwrite) NSNumber *boxNumber;
@property (strong, nonatomic, readwrite) SMRCostBenefit *costBenefit;

@property (weak, nonatomic) IBOutlet UILabel *boxHeaderLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addItemButton;

- (IBAction)addItemButtonTouchUpInside:(id)sender;

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

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"rowCell"];

    self.costBenefitItems = [self.costBenefit loadItemsForBoxNumber:self.boxNumber managedObjectContext:self.managedObjectContext];

    self.boxHeaderLabel.text = [self.costBenefit getBoxLabelText:self.boxNumber isPlural:YES];
}

#pragma mark - SMRCostBenefitBoxViewController

- (void)reloadData {
    self.costBenefitItems = [self.costBenefit loadItemsForBoxNumber:self.boxNumber managedObjectContext:self.managedObjectContext];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        NSLog(@"reloadData %@ -- count %li", self.boxNumber, self.costBenefitItems.count);
    });
}

- (IBAction)addItemButtonTouchUpInside:(id)sender {
    SMRCostBenefitItem *costBenefitItem = [SMRCostBenefitItem createCostBenefitItemInContext:self.managedObjectContext];
    costBenefitItem.boxNumber = self.boxNumber;
    costBenefitItem.costBenefit = self.costBenefit;
    SMREditCostBenefitItemViewController *addItemVC = [[SMREditCostBenefitItemViewController alloc] initWithCostBenefitItem:costBenefitItem managedObjectContext:self.managedObjectContext];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:addItemVC];
    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:navVC animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    NSInteger count = self.costBenefitItems.count;
//    NSLog(@"count = %li", (long)count);
    return self.costBenefitItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rowCell"];
    SMRCostBenefitItem *costBenefitItem = (SMRCostBenefitItem *)self.costBenefitItems[indexPath.row];
    cell.textLabel.text = costBenefitItem.title;
    return cell;
}

@end
