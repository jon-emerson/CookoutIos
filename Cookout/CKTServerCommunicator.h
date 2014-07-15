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
#import "CKTTokenExchangeDelegate.h"
#import "CKTPostOrderDelegate.h"

@interface CKTServerCommunicator : NSObject
@property (nonatomic, strong) NSMutableArray * listeners;

+ (void)syncDataModel;
+ (instancetype)sharedInstance;
+(void) dispatchSyncSuccess: (NSDictionary *) response;
+(void) dispatchSyncFailure: (AFHTTPRequestOperation *) operation;
+ (void)addSyncListener: (id) listener;
+ (void)placeOrder:(CKTOrder *)order addressIndex:(int) addressIndex
         delegate:(id<CKTDataModelChangeDelegate>)dataModelChangeDelegate;
+ (void)startSession;
+ (void)exchangeFbToken:(FBAccessTokenData *)fbToken delegate:(id<CKTTokenExchangeDelegate>) delegate;
+ (void)createCurrentUser:(id<CKTCreateUserHandler>)delegate;
+ (void)setUserAddress:(CKTAddress *)address
           currentUser:(CKTCurrentUser *)currentUser
              delegate:(id<CKTAddressSaveHandler>)delegate;
+(void)gmapsAutoComplete: (NSString *)substring delegate:(id<CKTGMapsAutoCompleter>) delegate;
+(void)getPlaceDetails:(NSString *) placeId delegate:(id<CKTGMapsAutoCompleter>) delegate;
@end
