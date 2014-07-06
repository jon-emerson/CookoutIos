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
@property (copy, readwrite) NSString *userId;
@property (copy, readwrite) NSString *name;
@property (copy, readwrite) NSString *sessionId;
@property (copy, readwrite) NSString *fbAccessToken;
@property (copy, nonatomic, readwrite) NSString *phone;
@property (copy, nonatomic, readwrite) NSString *email;
@property (retain, nonatomic, readwrite) NSMutableArray *addresses;
@end
