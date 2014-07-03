//
//  CKTAppDelegate.m
//  Cookout
//
//  Created by Jonathan Emerson on 6/16/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import "CKTAppDelegate.h"
#import "CKTDefines.h"
#import "CKTHomeViewController.h"
#import "CKTNavigationBar.h"
#include "CKTLoginManager.h"

@implementation CKTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    

    // Override point for customization after application launch.

    // Check Facebook login state
    [CKTLoginManager openFBSession];
    
    // Create a cookout home view controller
    CKTHomeViewController *hvc = [[CKTHomeViewController alloc] init];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithNavigationBarClass:[CKTNavigationBar class] toolbarClass:nil];

    // Push the home view controller on the nav controller
    navController.viewControllers = @[hvc];
    
    // Set the nav controller as the rootview controller of the window
    self.window.rootViewController = navController;
    
    // Add a red rectangle UIView at the top of the screen, behind the status bar
    // Only do this on iOS7 devices
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        UIView *statusBar = [[UIView alloc] init];
        statusBar.frame = CGRectMake(0, 0, self.window.frame.size.width, 20);
        statusBar.backgroundColor = UIColorFromRGB(0xED462F);
        [self.window.rootViewController.view addSubview:statusBar];
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    FBSession *session = [CKTFacebookSessionManager sharedFacebookSessionManager].session;
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:session];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[CKTFacebookSessionManager sharedFacebookSessionManager] applicationDidBecomeActive:application];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[CKTFacebookSessionManager sharedFacebookSessionManager] applicationWillTerminate:application];
}

@end
