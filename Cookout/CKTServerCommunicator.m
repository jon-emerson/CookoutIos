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
#import "CKTSessionHandlerDelegate.h"
#import "CKTAddressSaveHandler.h"
#import "CKTDataModel.h"
#import "CKTLoginManager.h"

@implementation CKTServerCommunicator

+ (void)syncDataModel:(id<CKTDataModelChangeDelegate>)dataModelChangeDelegate
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[CKTJSONResponseSerializer alloc] init];

    // Fire off an unauthenticated request to get an initial sense of dinners.
    
    [manager GET:@"http://immense-beyond-2989.herokuapp.com/readDinners" parameters:@{}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSDictionary *json = (NSDictionary *)responseObject;
              [CKTDataModelBuilder populateDataModelFromJSON:json];
              [dataModelChangeDelegate dataModelInitialized];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [dataModelChangeDelegate dataModelError:error];
          }];
}

+ (void)postOrder:(CKTOrder *)order delegate:(id<CKTDataModelChangeDelegate>)dataModelChangeDelegate
{
    NSString *baseURL = @"http://immense-beyond-2989.herokuapp.com/order";

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[CKTJSONResponseSerializer alloc] init];
    NSString *uId = order.user.userId;
    NSString *aId = order.user.addresses;
    NSString *dId = order.dinner.dinnerId;
    NSString *oQ = order.orderQuantity.stringValue;
    NSString *sR = order.specialRequests;
    
    NSDictionary *parameters = @{@"userId":(uId) ? uId : @"-1",
                                 @"addressId":(aId) ? aId : @"-1",
                                 @"dinnerId":(dId) ? dId :@"-1",
                                 @"orderQuantity":(oQ) ? oQ : @"-1",
                                 @"specialRequests":(sR) ? sR : @"None"};
    
    [manager POST:baseURL parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"JSON: %@", responseObject);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@  Operation: %@", error, operation);
          }];
}

+(void)startSession
{
    // The app has started - (1) Check if there is already CKTSession Token available
    CKTDataModel * sharedModel = [CKTDataModel sharedDataModel];
    if([sharedModel getUser].sessionId)
    {
        // already have a cookout session id. Life is good
        NSLog(@"Already have session token. Life is good");
        return;
    }
    else
    {
        // Initiate login manager to check for a facebook token
        // If login manager finds a token, it will call CKTServerCommunicator
        // to attempt to exchange the token for a CKTSession
        NSLog(@"Get an FB token and attempt exchange");
        [[CKTLoginManager sharedLoginManager] startFBSession];
    }
}

+(void)exchangeFbToken:(FBAccessTokenData *)fbToken
{
    NSString * URL = @"https://immense-beyond-2989.herokuapp.com/getSession";
    NSDictionary *parameters = @{@"fbAccessToken":fbToken.accessToken};

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[CKTJSONResponseSerializer alloc] init];

    [manager POST:URL parameters:parameters
          success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
              NSString *s = [responseObject valueForKey:@"success"];
              if(s.intValue == 1)
              {
                  NSLog(@"Token exchange succeeded! CK token %@", responseObject);
                  // Save the CKTToken to the user object and rejoice
                  NSString * sId = [responseObject valueForKey:@"sessionId"];
                  [[CKTDataModel sharedDataModel] setSession:sId];
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              // Tough luck - the server didn't want to exchange the token.
              // No worries, log the error and move on
              NSLog(@"Token exchange failed. %@", error);
          }];
}

+(void)createUser:(CKTUser *)user
{
    // If a user already exists, the return that user
    if([[CKTDataModel sharedDataModel]getUser].sessionId)
        return;

    NSString * URL = @"https://immense-beyond-2989.herokuapp.com/createUser";
    NSArray * keys = @[@"fbAccessToken",@"name",@"email",@"phone"];
    NSDictionary * parameters = [user dictionaryWithValuesForKeys:keys];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[CKTJSONResponseSerializer alloc] init];
    
    [manager POST:URL parameters:parameters
          success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
              NSLog(@"JSON: %@", responseObject);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@  Operation: %@", error, operation);
          }];
}

+(void)setUserAddress:(CKTAddress *)address user:(CKTUser *)user delegate:(id<CKTAddressSaveHandler>)delegate
{
    NSString * URL = @"https://immense-beyond-2989.herokuapp.com/addAddress";
    NSArray * addressKeys = @[@"addressLine1",@"addressLine2",@"unit",@"city",@"state",@"country",@"zipCode"];
    NSArray * userKeys = @[@"sessionId"];

    NSMutableDictionary * parameters = [[address dictionaryWithValuesForKeys:addressKeys]mutableCopy];
    NSMutableDictionary * userParams = [user dictionaryWithValuesForKeys:userKeys];
    
    [parameters addEntriesFromDictionary:userParams];
    
    NSLog(@"%@", parameters);
  
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[CKTJSONResponseSerializer alloc] init];
    [manager POST:URL parameters:parameters
          success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
              NSLog(@"%@", responseObject);
              [delegate addressSaved:responseObject];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"%@", error);
              [delegate addressSaveFailed:error];
          }];
}


@end