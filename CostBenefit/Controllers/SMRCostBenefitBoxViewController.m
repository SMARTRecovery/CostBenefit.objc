//
//  SMRCostBenefitBoxViewController.m
//  CostBenefit
//
//  Created by Aaron Schachter on 11/21/15.
//  Copyright © 2015 smartrecovery.org. All rights reserved.
//

#import "SMRCostBenefitBoxViewController.h"

@interface SMRCostBenefitBoxViewController ()

@property (weak, nonatomic) IBOutlet UILabel *boxHeaderLabel;

@end

@implementation SMRCostBenefitBoxViewController

- (instancetype)initWithBoxNumber:(NSNumber *)boxNumber costBenefitItems:(NSArray *)costBenefitItems managedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    self = [super initWithNibName:@"SMRCostBenefitBoxView" bundle:nil];

    if (self) {
        _boxNumber = boxNumber;
        _costBenefitItems = costBenefitItems;
        _managedObjectContext = managedObjectContext;
    }

    return self;

}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.boxHeaderLabel.text = [NSString stringWithFormat:@"Box number %@", self.boxNumber];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
