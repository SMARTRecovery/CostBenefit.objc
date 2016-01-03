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
@property (weak, nonatomic) IBOutlet UILabel *aboutCopyLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@property (weak, nonatomic) IBOutlet UIButton *appStoreButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet UIButton *websiteButton;

- (IBAction)appStoreButtonTouchUpInside:(id)sender;
- (IBAction)facebookButtonTouchUpInside:(id)sender;
- (IBAction)twitterButtonTouchUpInside:(id)sender;
- (IBAction)websiteButtonTouchUpInside:(id)sender;

@end

@implementation SMRAboutSmartRecoveryViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"About SMART Recovery";

    self.aboutCopyLabel.preferredMaxLayoutWidth = [[UIScreen mainScreen] bounds].size.width - 16;

    NSError *error;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"smart" ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    NSString *htmlString = [MMMarkdown HTMLStringWithMarkdown:content error:&error];
    UIFont *systemFont = [UIFont systemFontOfSize:15];
    NSString *aboutHTML = [NSString stringWithFormat:@"<html><head><style type=\"text/css\">body {font-family: \"%@\";font-size: %f;}</style></head><body>%@</body></html>", systemFont.familyName, 15.0f, htmlString];
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
    self.aboutCopyLabel.attributedText = [[NSAttributedString alloc] initWithData:[aboutHTML dataUsingEncoding:NSUTF8StringEncoding] options:options documentAttributes:nil error:&error];
    [self.websiteButton setImage:[IonIcons imageWithIcon:@"\uf4d3" size:24.0f color:self.view.tintColor] forState:UIControlStateNormal];
    [self.websiteButton setTitle:@"" forState:UIControlStateNormal];
    [self.facebookButton setImage:[IonIcons imageWithIcon:@"\uf231" size:24.0f color:self.view.tintColor] forState:UIControlStateNormal];
    [self.facebookButton setTitle:@"" forState:UIControlStateNormal];
    [self.twitterButton setImage:[IonIcons imageWithIcon:@"\uf243" size:24.0f color:self.view.tintColor] forState:UIControlStateNormal];
    [self.twitterButton setTitle:@"" forState:UIControlStateNormal];
    [self.appStoreButton setImage:[IonIcons imageWithIcon:@"\uf227" size:24.0f color:self.view.tintColor] forState:UIControlStateNormal];
}

#pragma mark - SMRAboutSmartRecoveryViewController

- (IBAction)appStoreButtonTouchUpInside:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms://itunes.apple.com/us/app/smart-recovery-cost-benefit/id988593978?mt=8"]];
}

- (IBAction)websiteButtonTouchUpInside:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.smartrecovery.org"]];
}

- (IBAction)facebookButtonTouchUpInside:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.facebook.com/smartrecoveryUSA"]];
}

- (IBAction)twitterButtonTouchUpInside:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.twitter.com/smartrecovery"]];
}

@end
