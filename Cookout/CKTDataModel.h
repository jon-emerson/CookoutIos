//
//  CKTDataModel.h
//  Cookout
//
//  Created by Jonathan Emerson on 6/25/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CKTAddress.h"
#import "CKTCurrentUser.h"
#import "CKTDinner.h"
#import "CKTUser.h"

@interface CKTDataModel : NSObject <NSCoding>

@property (nonatomic, retain) CKTCurrentUser *currentUser;

+ (instancetype)sharedDataModel;
- (NSArray *)dinners;
- (CKTUser *)userWithId:(NSString *)id;
- (void)addDinner:(CKTDinner *)dinner;
- (void)addUser:(CKTUser *)user;
- (BOOL)saveToDisk;
- (void)addAddress:(CKTAddress *)address;
- (CKTCurrentUser *)currentUser;
- (void)setSession:(NSString *) sId;
@end
