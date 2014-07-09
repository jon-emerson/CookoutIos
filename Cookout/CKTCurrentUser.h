//
//  CKTUser.h
//  Cookout
//  Model for a Cookout user
//  Created by Chandrashekar Raghavan on 7/2/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CKTCurrentUser : NSObject
@property (retain, readwrite) NSString *userId;
@property (retain, readwrite) NSString *name;
@property (retain, readwrite) NSString *sessionId;
@property (retain, readwrite) NSString *fbAccessToken;
@property (retain, nonatomic, readwrite) NSString *phone;
@property (retain, nonatomic, readwrite) NSString *email;

// @type NSMutableArray<CKTAddress *>
@property (retain, nonatomic, readwrite) NSMutableArray *addresses;
-(instancetype)initWithDictionary:(NSDictionary *) dictionary;

@end