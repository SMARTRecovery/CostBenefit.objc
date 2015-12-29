//
//  SMRAboutSmartRecoveryViewController.m
//  CostBenefit
//
//  Created by Aaron Schachter on 12/28/15.
//  Copyright © 2015 smartrecovery.org. All rights reserved.
//

#import "SMRAboutSmartRecoveryViewController.h"
#import <IonIcons.h>
#import <MMMarkdown/MMMarkdown.h>


@interface SMRAboutSmartRecoveryViewController ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *appStoreButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet UIButton *websiteButton;
- (IBAction)appStoreButtonTouchUpInside:(id)sender;
- (IBAction)websiteButtonTouchUpInside:(id)sender;

@end

@implementation SMRAboutSmartRecoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"About SMART Recovery";

    NSError *error;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"smart" ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    NSString *htmlString = [MMMarkdown HTMLStringWithMarkdown:content error:&error];
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
    self.contentLabel.attributedText = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUTF8StringEncoding] options:options documentAttributes:nil error:&error];
    self.contentLabel.font = [UIFont systemFontOfSize:17.0f];
}

- (IBAction)appStoreButtonTouchUpInside:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms://itunes.apple.com/us/app/smart-recovery-cost-benefit/id988593978?mt=8"]];
}

- (IBAction)websiteButtonTouchUpInside:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.smartrecovery.org"]];
}

@end
