//
//  SMRCostBenefitBoxViewController.m
//  CostBenefit
//
//  Created by Aaron Schachter on 11/21/15.
//  Copyright © 2015 smartrecovery.org. All rights reserved.
//

#import "SMRCostBenefitBoxViewController.h"
#import "SMRCostBenefitItem+methods.h"

@interface SMRCostBenefitBoxViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic, readwrite) NSNumber *boxNumber;
@property (strong, nonatomic, readwrite) SMRCostBenefit *costBenefit;

@property (weak, nonatomic) IBOutlet UILabel *boxHeaderLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SMRCostBenefitBoxViewController

#pragma mark - NSObject

- (instancetype)initWithCostBenefit:(SMRCostBenefit *)costBenefit boxNumber:(NSNumber *)boxNumber costBenefitItems:(NSArray *)costBenefitItems managedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    self = [super initWithNibName:@"SMRCostBenefitBoxView" bundle:nil];

    if (self) {
        _costBenefit = costBenefit;
        _boxNumber = boxNumber;
        _costBenefitItems = costBenefitItems;
        _managedObjectContext = managedObjectContext;
    }

    return self;

}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"rowCell"];

    self.boxHeaderLabel.text = [self.costBenefit getBoxLabelText:self.boxNumber isPlural:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
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
