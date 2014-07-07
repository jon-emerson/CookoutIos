    //
//  CKTLoginManager.m
//  Cookout
//
//  Created by Chandrashekar Raghavan on 7/2/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import "CKTLoginManager.h"
#import "CKTDataModel.h"
#import "CKTServerCommunicator.h"
#import "CKTFacebookSessionListener.h"
#import "CKTFacebookSessionManager.h"

@implementation CKTLoginManager

+ (instancetype)sharedLoginManager
{
    static CKTLoginManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedInstance) {
            sharedInstance = [[CKTLoginManager alloc] init];
        }
    });
    return sharedInstance;
}

// Start FB session
- (void)startFBSession
{
    NSLog(@"Opening FB session");
    CKTFacebookSessionManager *fbMgr = [CKTFacebookSessionManager sharedFacebookSessionManager];
    
    // Register login manager as a state change listener
    [fbMgr addListener:self];
    [fbMgr quietLogin];
}

// Start an FB session with login UI
- (void)startFBSessionWithLoginUI
{
    CKTFacebookSessionManager *fbMgr = [CKTFacebookSessionManager sharedFacebookSessionManager];
    [fbMgr login];
}

- (BOOL)isFacebookSessionOpen
{
    return (FBSession.activeSession.state == FBSessionStateOpen ||
            FBSession.activeSession.state == FBSessionStateOpenTokenExtended);
}

// Handle FB session state changes
- (void)handleFacebookSessionStateChange
{
    // If a valid facebook session is available, and no CKT session id available
    // then send the CKT server a request to exchange the FB session for a CKT session
    NSLog(@"Facebook session state change");
    CKTDataModel *sharedModel = [CKTDataModel sharedDataModel];
    if (sharedModel.currentUser.sessionId) {
        // Don't care about FB session changes, the user has a valid CKT Session
        NSLog(@"State change doesn't matter, got CKT Token");
        return;
    } else {
        NSLog(@"State change does matter - get me a CKT Token.");
        // ok check if the user has a valid FB session. If not, don't force UI here.
        if (FBSession.activeSession.state == FBSessionStateOpen ||
                FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
            // Exchange the FB session token for a cookout session
            NSLog(@"Active FB session, let's exchange it");
            [CKTServerCommunicator exchangeFbToken:FBSession.activeSession.accessTokenData];
        }
        else return;
    }
}

@end
