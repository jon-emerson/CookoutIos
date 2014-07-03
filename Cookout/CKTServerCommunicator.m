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

@implementation CKTServerCommunicator

+ (void)initializeDataModel:(id<CKTDataModelChangeDelegate>)dataModelChangeDelegate
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[CKTJSONResponseSerializer alloc] init];
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
    NSString *aId = order.user.deliveryAddress.addressId;
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

@end