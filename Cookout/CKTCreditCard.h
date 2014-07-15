//
//  CKTCreditCard.h
//  Cookout
//
//  Created by Chandrashekar Raghavan on 7/14/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CardType) {
    kVisa,
    kMaster,
    kAmex,
    kDiscover,
    kDiners,
    kInvalid
};

@interface CKTCreditCard : NSObject
@property (nonatomic, strong) NSString *sessionId;
@property (nonatomic, strong) NSString *ccNumber;
@property (nonatomic, strong) NSString *securityCode;
@property (nonatomic, strong) NSDate   *expiryDate;
@property (nonatomic) CardType ccType;
@property (nonatomic, strong) NSString *visbleCCDescription;
@property (nonatomic) int cardMinLength; // expected minimum length of card for this company
@property (nonatomic) int cardMaxLength; // expected maximum length of card for this company
@end
