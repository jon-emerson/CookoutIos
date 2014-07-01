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

+ (instancetype)sharedFacebookSessionManager;
- (void)applicationDidBecomeActive:(UIApplication *)application;
- (void)applicationWillTerminate:(UIApplication *)application;
- (void)login;
- (void)addListener:(id<CKTFacebookSessionListener>)listener;

@end
