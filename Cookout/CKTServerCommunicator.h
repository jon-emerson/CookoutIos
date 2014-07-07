//
//  CKTServerCommunicator.h
//  Cookout
//
//  Created by Jonathan Emerson on 6/25/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <FacebookSDK/FacebookSDK.h>

#import "CKTDataModelChangeDelegate.h"
#import "CKTAddressSaveHandler.h"
#import "CKTOrder.h"

@interface CKTServerCommunicator : NSObject

+ (void)syncDataModel:(id<CKTDataModelChangeDelegate>)dataModelChangeDelegate;
+ (void)postOrder:(CKTOrder *)order delegate:(id<CKTDataModelChangeDelegate>)dataModelChangeDelegate;
+ (void)startSession;
+ (void)exchangeFbToken:(FBAccessTokenData *)fbToken;
+ (void)createUser:(CKTUser *)user;
+ (void)setUserAddress:(CKTAddress *) address user:(CKTUser *) user delegate:(id<CKTAddressSaveHandler>)delegate;

@end
