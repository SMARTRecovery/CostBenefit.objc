//
//  SMRCostBenefitBoxTableViewCell.m
//  CostBenefit
//
//  Created by Aaron Schachter on 12/6/15.
//  Copyright © 2015 smartrecovery.org. All rights reserved.
//

#import "SMRCostBenefitBoxTableViewCell.h"

@interface SMRCostBenefitBoxTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *longTermLabel;

@end

@implementation SMRCostBenefitBoxTableViewCell

#pragma mark - Accessors

- (void)setTitleLabelText:(NSString *)titleLabelText {
    self.titleLabel.text = titleLabelText;
}

- (void)setLongTermLabelText:(NSString *)longTermLabelText {
    self.longTermLabel.text = longTermLabelText;
}

@end
