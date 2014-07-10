//
//  CKTFacebookSessionManager.h
//  Cookout
//
//  Created by Jonathan Emerson on 6/30/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

#import "CKTFacebookSessionListener.h"

@interface CKTFacebookSessionManager : NSObject

@property (strong, readonly) FBSession *session;
@property (strong, nonatomic) NSDictionary * userData;


+ (instancetype)sharedFacebookSessionManager;
- (void)applicationDidBecomeActive:(UIApplication *)application;
- (void)applicationWillTerminate:(UIApplication *)application;
- (void)login;
- (void)quietLogin;
- (void)addListener:(id<CKTFacebookSessionListener>)listener;

@end
