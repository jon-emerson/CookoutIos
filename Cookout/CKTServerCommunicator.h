//
//  CKTServerCommunicator.h
//  Cookout
//
//  Created by Jonathan Emerson on 6/25/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "CKTCreateUserHandler.h"
#import "CKTAddress.h"
#import "CKTAddressSaveHandler.h"
#import "CKTCurrentUser.h"
#import "CKTDataModelChangeDelegate.h"
#import "CKTOrder.h"
#import "CKTGMapsAutoCompleter.h"

@interface CKTServerCommunicator : NSObject

+ (void)syncDataModel:(id<CKTDataModelChangeDelegate>)dataModelChangeDelegate;
+ (void)placeOrder:(CKTOrder *)order addressIndex:(int) addressIndex
         delegate:(id<CKTDataModelChangeDelegate>)dataModelChangeDelegate;
+ (void)startSession;
+ (void)exchangeFbToken:(FBAccessTokenData *)fbToken;
+ (void)createCurrentUser:(id<CKTCreateUserHandler>)delegate;
+ (void)setUserAddress:(CKTAddress *)address
           currentUser:(CKTCurrentUser *)currentUser
              delegate:(id<CKTAddressSaveHandler>)delegate;
+(void)gmapsAutoComplete: (NSString *)substring delegate:(id<CKTGMapsAutoCompleter>) delegate;
+(void)getPlaceDetails:(NSString *) placeId delegate:(id<CKTGMapsAutoCompleter>) delegate;
@end
