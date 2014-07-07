//
//  CKTDataModelBuilder.m
//  Cookout
//
//  Created by Jonathan Emerson on 6/25/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import "CKTDataModel.h"
#import "CKTDataModelBuilder.h"

@implementation CKTDataModelBuilder

+ (void)populateDataModelFromJSON:(NSDictionary *)json
{
    CKTDataModel *dataModel = [CKTDataModel sharedDataModel];

    NSArray *users = [json valueForKey:@"users"];
    NSLog(@"User count: %d", users.count);
    for (NSDictionary *userDictionary in users) {
        [dataModel addUser:[[CKTUser alloc] initWithDictionary:userDictionary]];
    }

    NSArray *dinners = [json valueForKey:@"dinners"];
    NSLog(@"Dinner count: %d", dinners.count);
    for (NSDictionary *dinnerDictionary in dinners) {
        [dataModel addDinner:[[CKTDinner alloc] initWithDictionary:dinnerDictionary]];
    }
}

@end
