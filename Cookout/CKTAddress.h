//
//  CKTAddress.h
//  Cookout
//
//  Created by Chandrashekar Raghavan on 7/2/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CKTAddress : NSObject

// User's delivery address
@property (nonatomic, copy) NSString *addressId;
@property (nonatomic, copy) NSString *addressLine1;
@property (nonatomic, copy) NSString *addressLine2;
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *zipCode;

@end
