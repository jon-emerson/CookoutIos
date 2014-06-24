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
                    imageUrl:(NSURL *)imageUrl
             profileImageUrl:(NSURL *)profileImageUrl
                 ingredients:(NSArray *)ingredients
                 description:(NSString *)description
{
    self = [super init];
    
    if (self) {
        _name = name;
        _subtitle = subtitle;
        _imageUrl = imageUrl;
        _profileImageUrl = profileImageUrl;
        _ingredients = ingredients;
        _description = description;
    }
    
    return self;
}

- (instancetype)initWithName:(NSString *)name
                    subtitle:(NSString *)subtitle
               imageUrl:(NSURL *)imageUrl
        profileImageUrl:(NSURL *)profileImageUrl
{
    return [self initWithName:name
                     subtitle:subtitle
                     imageUrl:imageUrl
              profileImageUrl:profileImageUrl
                  ingredients:[[NSArray alloc] init]
                  description:@""];
}

@end
