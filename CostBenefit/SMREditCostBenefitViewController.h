//
//  SMREditCostBenefitViewController.h
//  SMARTRecovery
//
//  Created by Aaron Schachter on 3/30/15.
//  Copyright (c) 2015 smartrecovery.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+MMDrawerController.h"
#import "SMRCostBenefit+methods.h"

@interface SMREditCostBenefitViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) SMRCostBenefit *costBenefit;

@end
