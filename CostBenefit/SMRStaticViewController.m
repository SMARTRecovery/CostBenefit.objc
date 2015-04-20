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
    // Do any additional setup after loading the view.
    self.title = @"About CBA's";
    NSError  *error;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cba"
                                                     ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    NSString *htmlString = [MMMarkdown HTMLStringWithMarkdown:content error:&error];
    [self.webView loadHTMLString:htmlString baseURL:[[NSBundle mainBundle] bundleURL]];
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Button Handlers
-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
@end
