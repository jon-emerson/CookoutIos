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
@property (copy, readonly) NSString *imageFilename;
@property (copy, readonly) NSString *profileImageFilename;
@property (copy, readonly) NSArray *ingredients;
@property (copy, readonly) NSString *description;

// Designated initalizer for BNRItem.
- (instancetype)initWithName:(NSString *)name
                    subtitle:(NSString *)subtitle
               imageFilename:(NSString *)imageFilename
        profileImageFilename:(NSString *)profileImageFilename
                 ingredients:(NSArray *)ingredients
                 description:(NSString *)description;

- (instancetype)initWithName:(NSString *)name
                    subtitle:(NSString *)subtitle
               imageFilename:(NSString *)imageFilename
        profileImageFilename:(NSString *)profileImageFilename;

@end
