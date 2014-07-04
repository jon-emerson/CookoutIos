//
//  CKTFacebookSessionManager.m
//  Cookout
//
//  Created by Jonathan Emerson on 6/30/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import "CKTFacebookSessionManager.h"

@interface CKTFacebookSessionManager ()
@property (strong, nonatomic) NSMutableArray *listeners;
@end

@implementation CKTFacebookSessionManager

+ (instancetype)sharedFacebookSessionManager
{
    static CKTFacebookSessionManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedInstance) {
            sharedInstance = [[CKTFacebookSessionManager alloc] init];
        }
    });
    return sharedInstance;
}

- (void)dispatchStateChange
{
    for (id<CKTFacebookSessionListener> listener in self.listeners) {
        [listener handleFacebookSessionStateChange];
    }
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _listeners = [[NSMutableArray alloc] init];
        
        if (!self.session.isOpen) {
            // create a fresh session object
            _session = [[FBSession alloc] init];
            
            // if we don't have a cached token, a call to open here would cause UX for login to
            // occur; we don't want that to happen unless the user clicks the login button, and so
            // we check here to make sure we have a token before calling open
            if (self.session.state == FBSessionStateCreatedTokenLoaded) {
                // even though we had a cached token, we need to login to make the session usable
                [self.session openWithCompletionHandler:^(FBSession *session,
                                                                 FBSessionState status,
                                                                 NSError *error) {
                    [self dispatchStateChange];
                }];
            } else {
                [self dispatchStateChange];
            }
        } else {
            [self dispatchStateChange];
        }
    }
    
    return self;
};

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBAppEvents activateApp];
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppCall handleDidBecomeActiveWithSession:self.session];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self.session close];
}

- (void)login
{
    NSLog(@"FBSession.activeSession.state = %u", FBSession.activeSession.state);
    
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // The user is already logged in.  Just dispatch an event so that the UI
        // properly updates itself.
        [self dispatchStateChange];
        return;
    }
    
    [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email"] // , @"user_friends", @"email"]
                                       allowLoginUI:YES
                                  completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             _session = session;
             [self dispatchStateChange];
         }];
}

- (void)addListener:(id<CKTFacebookSessionListener>)listener
{
    [self.listeners addObject:listener];
}

@end
