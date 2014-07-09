//
//  CKTUser.m
//  Cookout
//
//  Created by Chandrashekar Raghavan on 7/2/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import "CKTCurrentUser.h"

@implementation CKTCurrentUser

- (instancetype)init
{
    self = [super init];
    if (self) {
        // Initialize an empty user object
    }
    return self;
}

- (instancetype) initWithDictionary:(NSDictionary *)currentUser
{
    self = [super init];
    if(self)
    {
        _userId = [currentUser valueForKey:@"userId"];
        _sessionId = [currentUser valueForKey:@"sessionId"];
        _name = [currentUser valueForKey:@"name"];
        _email = [currentUser valueForKey:@"email"];
        _phone = [currentUser valueForKey:@"phone"];
        _addresses = [currentUser valueForKey:@"addresses"];
    }
    
    return self;
}

@end
