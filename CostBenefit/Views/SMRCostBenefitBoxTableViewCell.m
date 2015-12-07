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

@end


@implementation SMRCostBenefitBoxTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setTitleLabelText:(NSString *)titleLabelText {
    self.titleLabel.text = titleLabelText;
}

@end
