//
//  CKTDataModel.h
//  Cookout
//
//  Created by Jonathan Emerson on 6/25/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CKTChef.h"
#import "CKTDinner.h"
#import "CKTUser.h"

@interface CKTDataModel : NSObject <NSCoding>
+ (instancetype)sharedDataModel;
- (NSArray *)dinners;
- (CKTChef *)chefWithId:(NSString *)id;
- (void)addDinner:(CKTDinner *)dinner;
- (void)addChef:(CKTChef *)chef;
- (BOOL)saveToDisk;
- (void)addUser:(NSObject *) u;
- (CKTUser *)getUser;
@end
