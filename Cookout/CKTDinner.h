//
//  CKTDinner.h
//  Cookout
//
//  Created by Jonathan Emerson on 6/17/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CKTDinner : NSObject <NSCoding>

@property (copy, readonly) NSString *dinnerId;
@property (copy, readonly) NSString *name;
@property (copy, readonly) NSString *chefId;
@property (copy, readonly) NSString *imageFilename;
@property (copy, readonly) NSNumber *price;
@property (copy, readonly) NSNumber *numAvailable;
@property (copy, readonly) NSDate *orderByDateTime;
@property (copy, readonly) NSDate *deliveryDateTime;
@property (copy, readonly) NSArray *ingredients;
@property (copy, readonly) NSString *description;

// Designated initalizer for BNRItem.
- (instancetype)initWithDinnerId:(NSString *)dinnerId
                            name:(NSString *)name
                          chefId:(NSString *)chefId
                   imageFilename:(NSString *)imageFilename
                           price:(NSNumber *)price
                    numAvailable:(NSNumber *)numAvailable
                 orderByDateTime:(NSDate *)orderByDateTime
                deliveryDateTime:(NSDate *)deliveryDateTime
                     ingredients:(NSArray *)ingredients
                     description:(NSString *)description;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (NSURL *)imageUrl;

@end
