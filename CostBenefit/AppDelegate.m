//
//  AppDelegate.m
//  SMARTRecovery
//
//  Created by Aaron Schachter on 3/23/15.
//  Copyright (c) 2015 smartrecovery.org. All rights reserved.
//

#import "AppDelegate.h"
#import "SMRCoreDataStack.h"
#import "SMRLeftMenuViewController.h"
#import "SMRCostBenefitTableViewController.h"
#import "SMREditCostBenefitViewController.h"
#import "SMRCostBenefit+methods.h"
#import "SMRCostBenefitViewController.h"
#import <MMDrawerController.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (NSURL*)storeURL{
    NSURL* documentsDirectory = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:NULL];
    return [documentsDirectory URLByAppendingPathComponent:@"db.sqlite"];
}

- (NSURL*)modelURL{
    return [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    SMRCoreDataStack *coreDataStack = [[SMRCoreDataStack alloc] initWithStoreURL:[self storeURL] modelURL:[self modelURL]];

    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    MMDrawerController *drawerController = [mainStoryboard instantiateViewControllerWithIdentifier:@"drawerController"];

    UINavigationController *leftMenuNavVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"leftMenuNavigationController"];
    SMRLeftMenuViewController *leftMenuVC = (SMRLeftMenuViewController *)leftMenuNavVC.topViewController;
    leftMenuVC.context = coreDataStack.managedObjectContext;
    [drawerController setLeftDrawerViewController:leftMenuNavVC];

    BOOL savedCostBenefit = NO;
    SMRCostBenefit *costBenefit;

    NSMutableArray *costBenefits = [SMRCostBenefit fetchAllCostBenefitsInContext:coreDataStack.managedObjectContext];
    UINavigationController *centerController;
    if ([costBenefits count] > 0) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSURL *costBenefitURL = [defaults URLForKey:@"SMRLastViewedCostBenefit"];
        if (costBenefitURL != nil) {
            NSManagedObjectID *moID = [coreDataStack.managedObjectContext.persistentStoreCoordinator managedObjectIDForURIRepresentation:costBenefitURL];
            NSError *error;
            if ([coreDataStack.managedObjectContext existingObjectWithID:moID error:&error]) {
                savedCostBenefit = YES;
                costBenefit = (SMRCostBenefit *)[coreDataStack.managedObjectContext objectWithID:moID];
                SMRCostBenefitViewController *costBenefitVC = [[SMRCostBenefitViewController alloc] initWithCostBenefit:costBenefit managedObjectContext:coreDataStack.managedObjectContext];
                UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:costBenefitVC];
                centerController = navVC;
            }
        }
    }

    if (!savedCostBenefit) {
        centerController = [mainStoryboard instantiateViewControllerWithIdentifier:@"editCostBenefitNavVC"];
        SMREditCostBenefitViewController *destVC = (SMREditCostBenefitViewController *)centerController.topViewController;
        [destVC setContext:coreDataStack.managedObjectContext];
    }


    [drawerController setCenterViewController:centerController withFullCloseAnimation:NO completion:nil];
    [drawerController setShowsShadow:YES];
    [drawerController setShadowRadius:0.9];


    self.window.rootViewController = drawerController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
