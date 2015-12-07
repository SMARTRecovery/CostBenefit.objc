//
//  SMRCostBenefitBoxTableViewCell.h
//  CostBenefit
//
//  Created by Aaron Schachter on 12/6/15.
//  Copyright © 2015 smartrecovery.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMRCostBenefitItem.h"

@interface SMRCostBenefitBoxTableViewCell : UITableViewCell

@property (strong, nonatomic) NSString *titleLabelText;
@property (strong, nonatomic) SMRCostBenefitItem *costBenefitItem;

@end
