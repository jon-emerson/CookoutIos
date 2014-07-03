//
//  CKTLoginManager.m
//  Cookout
//
//  Created by Chandrashekar Raghavan on 7/2/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import "CKTLoginManager.h"

@implementation CKTLoginManager

+ (void)openFBSession
{
    [FBLoginView class];
    // Whenever a person opens the app, check for a cached session
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        
        // If there's one, just open the session silently, without showing the user the login UI
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          // Handler for session state changes
                                          // This method will be called EACH time the session state changes,
                                          // also for intermediate states and NOT just when the session open
                                          [CKTLoginManager sessionStateChanged:session state:state error:error];
                                      }];
        
    }
}

+ (void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error
{
    NSLog(@"Facebook login state changed and I got here");
}

@end
