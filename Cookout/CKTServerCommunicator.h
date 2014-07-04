//
//  CKTServerCommunicator.h
//  Cookout
//
//  Created by Jonathan Emerson on 6/25/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "CKTDataModelChangeDelegate.h"
#import "CKTOrder.h"
#import <FacebookSDK/FacebookSDK.h>

@interface CKTServerCommunicator : NSObject
+(void)initializeDataModel:(id<CKTDataModelChangeDelegate>)dataModelChangeDelegate;
+(void)postOrder:(CKTOrder *)order delegate:(id<CKTDataModelChangeDelegate>)dataModelChangeDelegate;
+(void)getCKTSession:(FBAccessTokenData *)fbToken delegate:(id)delegate;
+(void)createUser:(CKTUser *)user;
+(void)setUserAddress:(CKTAddress *) address user:(CKTUser *) user;
@end
