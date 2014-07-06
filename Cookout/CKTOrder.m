//
//  CKTOrder.m
//  Cookout
//  
//  Created by Chandrashekar Raghavan on 7/2/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import "CKTOrder.h"

@implementation CKTOrder

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        // Initialize an empty user object
        self.dinner = [[CKTDinner alloc]init];
        self.user = [[CKTUser alloc]init];
        self.orderQuantity = [[NSNumber alloc]init];
        self.specialRequests = [[NSString alloc]init];
    }
    return self;
}

@end
