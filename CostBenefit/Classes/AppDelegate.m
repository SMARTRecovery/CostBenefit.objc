//
//  AppDelegate.m
//  SMARTRecovery
//
//  Created by Aaron Schachter on 3/23/15.
//  Copyright (c) 2015 smartrecovery.org. All rights reserved.
//

#import "AppDelegate.h"
#import "SMRCoreDataStack.h"
#import "SMRHomeViewController.h"
#import <IonIcons.h>

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
    SMRHomeViewController *homeViewController = [[SMRHomeViewController alloc] initWithManagedObjectContext:coreDataStack.managedObjectContext];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    navigationController.navigationBar.translucent = NO;
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    UIImage *closeImage = [IonIcons imageWithIcon:@"\uf404" size:22.0f color:homeViewController.view.tintColor];
    [[UINavigationBar appearance] setBackIndicatorImage:closeImage];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:closeImage];

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
