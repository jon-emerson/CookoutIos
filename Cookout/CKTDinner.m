//
//  CKTDinner.m
//  Cookout
//
//  Created by Jonathan Emerson on 6/17/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import "CKTDinner.h"

@implementation CKTDinner

- (instancetype)init
{
    return nil;
}

- (instancetype)initWithName:(NSString *)name
                    subtitle:(NSString *)subtitle
               imageFilename:(NSString *)imageFilename
        profileImageFilename:(NSString *)profileImageFilename
                 ingredients:(NSArray *)ingredients
                 description:(NSString *)description
{
    self = [super init];
    
    if (self) {
        _name = name;
        _subtitle = subtitle;
        _imageFilename = imageFilename;
        _profileImageFilename = profileImageFilename;
        _ingredients = ingredients;
        _description = description;
    }
    
    return self;
}

- (instancetype)initWithName:(NSString *)name
                    subtitle:(NSString *)subtitle
               imageFilename:(NSString *)imageFilename
        profileImageFilename:(NSString *)profileImageFilename
{
    return [self initWithName:name
                     subtitle:subtitle
                imageFilename:imageFilename
         profileImageFilename:profileImageFilename
                  ingredients:[[NSArray alloc] init]
                  description:@""];
}

@end
