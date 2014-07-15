//
//  CKTServerCommunicator.m
//  Cookout
//
//  Created by Jonathan Emerson on 6/25/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import "CKTDataModelBuilder.h"
#import "CKTDataModelChangeDelegate.h"
#import "CKTJSONResponseSerializer.h"
#import "CKTServerCommunicator.h"
#import "CKTOrder.h"
#import "CKTAddressSaveHandler.h"
#import "CKTDataModel.h"
#import "CKTLoginManager.h"
#include "CKTGMapsAutoCompleter.h"

@implementation CKTServerCommunicator

+ (instancetype)sharedInstance
{
    static CKTServerCommunicator *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedInstance) {
            sharedInstance = [[CKTServerCommunicator alloc] init];
            sharedInstance.listeners = [[NSMutableArray alloc]init];
        }
    });
    return sharedInstance;
}

+(void) dispatchSyncSuccess: (NSDictionary *) response
{
    CKTServerCommunicator *sharedInstance = [CKTServerCommunicator sharedInstance];
    for(NSObject *listner in sharedInstance.listeners)
    {
        [(id<CKTDataModelChangeDelegate>)listner dataModelInitialized];
    }
}

+(void) dispatchSyncFailure: (AFHTTPRequestOperation *) operation
{
    CKTServerCommunicator *sharedInstance = [CKTServerCommunicator sharedInstance];
    for(NSObject *listner in sharedInstance.listeners)
    {
        [(id<CKTDataModelChangeDelegate>)listner dataModelInitialized];
    }
}

+ (void)addSyncListener: (id) listener
{
    CKTServerCommunicator *sharedInstance = [CKTServerCommunicator sharedInstance];
    [sharedInstance.listeners addObject:listener];
}

+ (void)syncDataModel
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[CKTJSONResponseSerializer alloc] init];

    // Fire off an unauthenticated request to get an initial sense of dinners.
    
    [manager GET:@"http://immense-beyond-2989.herokuapp.com/getUserState" parameters:@{}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSDictionary *json = (NSDictionary *)responseObject;
              [CKTDataModelBuilder populateDataModelFromJSON:json];
              [CKTServerCommunicator dispatchSyncSuccess:responseObject];
              //[dataModelChangeDelegate dataModelInitialized];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              //[dataModelChangeDelegate dataModelError:error];
              [CKTServerCommunicator dispatchSyncFailure:operation];
          }];
}

+ (void)placeOrder:(CKTOrder *)order addressIndex: (int) addressIndex
         delegate:(id<CKTPostOrderDelegate>)delegate
{
    NSString *baseURL = @"http://immense-beyond-2989.herokuapp.com/order";
    CKTCurrentUser *user = [CKTCurrentUser sharedInstance];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[CKTJSONResponseSerializer alloc] init];
    
    NSString *sessionId = user.sessionId;
    NSString *dId = order.dinner.dinnerId;
    NSString *oQ = order.orderQuantity.stringValue;
    NSString *sR = order.specialRequests;
    NSString *aId = ((CKTAddress *)user.addresses[addressIndex]).addressId;

    NSDictionary *parameters = @{@"sessionId":(sessionId),
                                 @"addressId":(aId),
                                 @"dinnerId":(dId),
                                 @"orderQuantity":(oQ),
                                 @"specialRequests":(sR) ? sR : @"None"};
    
    [manager POST:baseURL parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              [delegate orderSucceeded:responseObject];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@  Operation: %@", error, operation);
              [delegate orderFailed:error operation:operation];
          }];
}

+ (void)startSession
{
    // The app has started.
    // Step 1. Check if there is already CKTSession Token available.
    CKTDataModel *sharedModel = [CKTDataModel sharedDataModel];
    if (sharedModel.currentUser.sessionId) {
        // already have a cookout session id. Life is good
        NSLog(@"Already have session token. Life is good");
        return;
    }
    
    // Initiate login manager to check for a facebook token
    // If login manager finds a token, it will call CKTServerCommunicator
    // to attempt to exchange the token for a CKTSession
    NSLog(@"Get an FB token and attempt exchange");
    [[CKTLoginManager sharedLoginManager] startFBSession];
}

+ (void)exchangeFbToken:(FBAccessTokenData *)fbToken delegate: (id) delegate
{
    NSString *url = @"https://immense-beyond-2989.herokuapp.com/getSession";
    NSDictionary *parameters = @{@"fbAccessToken":fbToken.accessToken};

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[CKTJSONResponseSerializer alloc] init];

    [manager POST:url parameters:parameters
          success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
              NSString *s = [responseObject valueForKey:@"success"];
              if (s.intValue == 1) {
                  NSLog(@"Token exchange succeeded! CK token %@", responseObject);
                  // Save the CKTToken to the user object and rejoice
                  NSString *sId = [responseObject valueForKey:@"sessionId"];
                  [[CKTDataModel sharedDataModel] setSession:sId];
              }
              [delegate exchangeSucceeded:responseObject];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              // Tough luck - the server didn't want to exchange the token.
              // No worries, log the error and move on
              NSLog(@"Token exchange failed. %@", error);
              [delegate exchangeFailed:error operation:operation];
          }];
}

+ (void)createCurrentUser:(id<CKTCreateUserHandler>)delegate
{
    // If a user already exists, the return that user.
    if (CKTDataModel.sharedDataModel.currentUser.sessionId) {
        return;
    }
    
    CKTCurrentUser *user = [CKTCurrentUser sharedInstance];
    
    NSString *url = @"https://immense-beyond-2989.herokuapp.com/createUser";
    NSArray *keys = @[@"fbAccessToken", @"name", @"email", @"phoneNumber"];
    NSDictionary *parameters = [user dictionaryWithValuesForKeys:keys];
    

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[CKTJSONResponseSerializer alloc] init];
    
    [manager POST:url parameters:parameters
          success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
              NSLog(@"JSON: %@", responseObject);
              [CKTCurrentUser sharedInstance].sessionId = [[responseObject valueForKey:@"sessionId"] copy];
              [delegate createUserSucceeded:responseObject];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@  Operation: %@", error, operation.responseObject);
              [delegate createUserFailed:error operation:operation];
          }];
}

+ (void)setUserAddress:(CKTAddress *)address
           currentUser:(CKTCurrentUser *)currentUser
              delegate:(id<CKTAddressSaveHandler>)delegate
{
    NSString *url = @"https://immense-beyond-2989.herokuapp.com/addAddress";
    NSArray *addressKeys = @[@"addressLine1", @"addressLine2", @"unit", @"city",
                             @"state", @"country", @"zipCode"];
    NSArray *userKeys = @[@"sessionId"];

    NSMutableDictionary *parameters = [[address dictionaryWithValuesForKeys:addressKeys]mutableCopy];
    NSDictionary *currentUserParams =
            [currentUser dictionaryWithValuesForKeys:userKeys];
    [parameters addEntriesFromDictionary:currentUserParams];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[CKTJSONResponseSerializer alloc] init];
    [manager POST:url parameters:parameters
          success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
              NSLog(@"%@", responseObject);
              [delegate addressSaved:responseObject];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"%@", error);
              [delegate addressSaveFailed:error operation:operation];
          }];
}

+(void)gmapsAutoComplete:(NSString *)substring delegate:(id<CKTGMapsAutoCompleter>) delegate
{
    NSString * apiKey = @"AIzaSyAfagTr9VXJ-imio0CpRT9wdkOtTa7Jz8g";
    NSString *url = @"https://maps.googleapis.com/maps/api/place/autocomplete/json";
    // input=Vict&types=geocode&language=fr&key=API_KEY
    
    NSDictionary * parameters = @{@"key":apiKey,
                                     @"input":substring,
                                     @"types":@"geocode",
                                     @"language":@"en",
                                     @"location":@"37.745322,-122.4514656",
                                     @"radius":@"6438"};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[CKTJSONResponseSerializer alloc] init];
    
    [manager GET:url parameters:parameters
          success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
              //NSLog(@"%@", responseObject);
              [delegate autoCompleteSuggestions:responseObject];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"%@", error);
          }];
}

+(void)getPlaceDetails:(NSString *)placeReference delegate:(id<CKTGMapsAutoCompleter>) delegate
{
    NSString * apiKey = @"AIzaSyAfagTr9VXJ-imio0CpRT9wdkOtTa7Jz8g";
    NSString *url = @"https://maps.googleapis.com/maps/api/place/details/json";
    // input=Vict&types=geocode&language=fr&key=API_KEY
    
    NSDictionary * parameters = @{@"key":apiKey, @"reference":placeReference};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[CKTJSONResponseSerializer alloc] init];
    
    [manager GET:url parameters:parameters
         success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
             //NSLog(@"%@", responseObject);
             [delegate placeDetailsReceived:responseObject];
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"%@", error);
         }];
}




@end