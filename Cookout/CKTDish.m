//
//  CKTDish.m
//  Cookout
//
//  Created by Jonathan Emerson on 6/16/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import "CKTDish.h"

@implementation CKTDish

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
