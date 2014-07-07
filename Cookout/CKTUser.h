//
//  CKTChef.h
//  Cookout
//
//  Created by Jonathan Emerson on 6/25/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CKTUser : NSObject <NSCoding>

@property (copy, readonly) NSString *userId;
@property (copy, readonly) NSString *name;
@property (copy, readonly) NSString *imageUrl;
@property (readonly) float starRating;

// Designated initalizer for CKTChef.
- (instancetype)initWithUserId:(NSString *)userId
                          name:(NSString *)name
                      imageUrl:(NSString *)imageUrl;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (NSURL *)imageNSUrl;

@end
