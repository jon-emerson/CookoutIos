//
//  CKTUser.h
//  Cookout
//  Model for a Cookout user
//  Created by Chandrashekar Raghavan on 7/2/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CKTUser : NSObject
//TODO: Should these properties be copy
@property (copy, readonly) NSString *FBUserId;
@property (copy, readonly) NSString *name;
@property (copy, readonly) NSString *phone;
@property (copy, readonly) NSString *email;

// User's delivery address
@property (nonatomic, copy) NSString * streetAddressLine1;
@property (nonatomic, copy) NSString * streetAddressLine2;
@property (nonatomic, copy) NSString * unit;
@property (nonatomic, copy) NSString * city;
@property (nonatomic, copy) NSString * state;
@property (nonatomic, copy) NSString * country;
@property (nonatomic, copy) NSString * zipcode;

@end
