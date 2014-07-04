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

@implementation CKTServerCommunicator

+ (void)syncDataModel:(id<CKTDataModelChangeDelegate>)dataModelChangeDelegate
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[CKTJSONResponseSerializer alloc] init];
    
    // Look at existing data model - possible states
    // (1) completely unintiliazed
    // (2) initialized with stale data
    
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

+(void)getCKTSession:(FBAccessTokenData *)fbToken delegate:(id<CKTSessionHandlerDelegate>)delegate
{
    
    NSString * URL = @"https://immense-beyond-2989.herokuapp.com/getSession";
    NSDictionary *parameters = @{@"fbAccessToken":fbToken.accessToken};

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[CKTJSONResponseSerializer alloc] init];

    [manager POST:URL parameters:parameters
          success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
              [delegate sessionRequestResponse:responseObject];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [delegate sessionRequestError:error];
          }];
}

+(void)createUser:(CKTUser *)user
{
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
    NSArray * addressKeys = @[@"addressLine1",@"addressLine2",@"unit",@"city",@"state",@"country",@"zipcode"];
    NSArray * userKeys = @[@"sessionId"];

    NSMutableDictionary * parameters = [[address dictionaryWithValuesForKeys:addressKeys]mutableCopy];
    NSMutableDictionary * userParams = [user dictionaryWithValuesForKeys:userKeys];
    
    [parameters addEntriesFromDictionary:userParams];
  
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[CKTJSONResponseSerializer alloc] init];
    
    [manager POST:URL parameters:parameters
          success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
              NSLog(@"%@", responseObject);
              [delegate addressSaved:responseObject];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [delegate addressSaveFailed:error];
          }];
}


@end