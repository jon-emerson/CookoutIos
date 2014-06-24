//
//  CKTDinner.h
//  Cookout
//
//  Created by Jonathan Emerson on 6/17/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CKTDinner : NSObject

@property (copy, readonly) NSString *name;
@property (copy, readonly) NSString *subtitle;
@property (copy, readonly) NSURL *imageUrl;
@property (copy, readonly) NSURL *profileImageUrl;
@property (copy, readonly) NSArray *ingredients;
@property (copy, readonly) NSString *description;

// Designated initalizer for BNRItem.
- (instancetype)initWithName:(NSString *)name
                    subtitle:(NSString *)subtitle
                    imageUrl:(NSURL *)imageUrl
             profileImageUrl:(NSURL *)profileImageUrl
                 ingredients:(NSArray *)ingredients
                 description:(NSString *)description;

- (instancetype)initWithName:(NSString *)name
                    subtitle:(NSString *)subtitle
                    imageUrl:(NSURL *)imageUrl
             profileImageUrl:(NSURL *)profileImageUrl;

@end
