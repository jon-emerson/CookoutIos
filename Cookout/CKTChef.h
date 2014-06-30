//
//  CKTChef.h
//  Cookout
//
//  Created by Jonathan Emerson on 6/25/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CKTChef : NSObject

@property (copy, readonly) NSString *chefId;
@property (copy, readonly) NSString *name;
@property (copy, readonly) NSString *imageFilename;

// Designated initalizer for CKTChef.
- (instancetype)initWithChefId:(NSString *)chefId
                          name:(NSString *)name
                 imageFilename:(NSString *)imageFilename;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (NSURL *)imageUrl;

@end
