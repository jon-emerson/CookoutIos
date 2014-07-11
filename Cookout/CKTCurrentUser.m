//
//  CKTUser.m
//  Cookout
//
//  Created by Chandrashekar Raghavan on 7/2/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import "CKTCurrentUser.h"

@implementation CKTCurrentUser
+ (instancetype)sharedInstance
{
    static CKTCurrentUser *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedInstance) {
            sharedInstance = [[CKTCurrentUser alloc] init];
        }
    });
    return sharedInstance;
}

- (instancetype) setCurrentUser:(NSDictionary *)currentUser
{
    if(self)
    {
        self.userId = [currentUser valueForKey:@"userId"];
        self.sessionId = [currentUser valueForKey:@"sessionId"];
        self.name = [currentUser valueForKey:@"name"];
        self.email = [currentUser valueForKey:@"email"];
        self.phoneNumber = [currentUser valueForKey:@"phoneNumber"];
        self.addresses = [currentUser valueForKey:@"addresses"];
    }
    
    return self;
}

-(void) addAddress: (CKTAddress *)address
{
    if(!self.addresses)
        self.addresses = [[NSMutableArray alloc]init];
    [self.addresses addObject:address];
}

@end
