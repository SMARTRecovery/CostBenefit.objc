//
//  SMRStaticViewController.h
//  CostBenefit
//
//  Created by Aaron Schachter on 4/20/15.
//  Copyright (c) 2015 smartrecovery.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMRStaticViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) NSString *contentFileName;

- (instancetype)initWithContentFileName:(NSString *)contentFileName;
    
@end
