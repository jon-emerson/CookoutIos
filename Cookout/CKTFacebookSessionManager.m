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
    
    if (self)
    {
        _listeners = [[NSMutableArray alloc] init];
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
    
    /*[FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email"] // , @"user_friends", @"email"]
                                       allowLoginUI:YES
                                  completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             _session = session;
             [self dispatchStateChange];
         }];*/
    
    [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email"]
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
         if(!error && state == FBSessionStateOpen) {
             { [FBRequestConnection startWithGraphPath:@"me" parameters:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"name,email",@"fields",nil] HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                 self.userData = (NSDictionary *)result;
                 NSLog(@"%@",[self.userData description]);
                 [self dispatchStateChange];
             }];
             }
         }
     }];
}

- (void)quietLogin
{
    NSLog(@"FBSession.activeSession.state = %u", FBSession.activeSession.state);
    
    // Attempt a silent login
    
    // TODO: Seems like the completion handler doesn't get called if the user doesn't grant
    // access to all requested scopes
        
    [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email"]
                                       allowLoginUI:NO
                                  completionHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
         NSLog(@"Did this call back ever happen");
         if(!error && state == FBSessionStateOpen) {
             { [FBRequestConnection startWithGraphPath:@"me" parameters:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"name,email",@"fields",nil] HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                 self.userData = (NSDictionary *)result;
                 NSLog(@"%@",[self.userData description]);
                 [self dispatchStateChange];
             }];
             }
         }
     }];
    
     /*[FBSession openActiveSessionWithReadPermissions:@[@"public_profile",@"email"] // , @"user_friends", @"email"]
                                       allowLoginUI:NO
                                  completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                                _session = session;
                                                [self dispatchStateChange];
                                  }];*/
}

- (void)addListener:(id<CKTFacebookSessionListener>)listener
{
    [self.listeners addObject:listener];
}

@end
