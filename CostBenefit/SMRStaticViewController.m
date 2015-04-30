//
//  SMRStaticViewController.m
//  CostBenefit
//
//  Created by Aaron Schachter on 4/20/15.
//  Copyright (c) 2015 smartrecovery.org. All rights reserved.
//

#import "SMRStaticViewController.h"
#import "MMDrawerBarButtonItem.h"
#import <MMMarkdown/MMMarkdown.h>

@interface SMRStaticViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation SMRStaticViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.delegate = self;

    self.title = @"About SMART Recovery";
    if ([self.txtFileName isEqualToString:@"cba"]) {
        self.title = @"About CBA's";
    }

    NSError  *error;
    NSString *path = [[NSBundle mainBundle] pathForResource:self.txtFileName
                                                     ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    NSString *htmlString = [MMMarkdown HTMLStringWithMarkdown:content error:&error];
    NSString *aboutHTML = [NSString stringWithFormat:@"<html> \n"
                                   "<head> \n"
                                   "<style type=\"text/css\"> \n"
                                   "body {font-family: \"%@\"; font-size: %@;}\n"
                                   "</style> \n"
                                   "</head> \n"
                                   "<body>%@</body> \n"
                                   "</html>", @"helvetica", [NSNumber numberWithInt:14], htmlString];
    [self.webView loadHTMLString:aboutHTML baseURL:[[NSBundle mainBundle] bundleURL]];
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }

    return YES;
}

#pragma mark - Button Handlers
-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
@end
