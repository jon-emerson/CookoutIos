//
//  CKTOrder.h
//  Cookout
//  Model for a Cookout order
//  that is to be placed on Cookout
//  Created by Chandrashekar Raghavan on 7/2/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKTUser.h"
#import "CKTDinner.h"

@interface CKTOrder : NSObject
@property (nonatomic, strong) CKTUser * user;
@property (nonatomic, strong) CKTDinner * dinner;
@property (nonatomic, copy) NSNumber * orderQuantity;
@property (nonatomic, copy) NSString * deliveryInstructions;
@end
