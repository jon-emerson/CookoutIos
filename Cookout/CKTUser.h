//
//  CKTUser.h
//  Cookout
//  Model for a Cookout user
//  Created by Chandrashekar Raghavan on 7/2/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKTAddress.h"

@interface CKTUser : NSObject
//TODO: Should these properties be copy
@property (copy, readonly) NSString *FBUserId;
@property (copy, readonly) NSString *name;
@property (copy, nonatomic, readwrite) NSString *phone;
@property (copy, nonatomic, readwrite) NSString *email;
@property (copy, nonatomic, readwrite) CKTAddress *deliveryAddress;
@property (copy, nonatomic, readwrite) CKTAddress *billingAddress;
@end
