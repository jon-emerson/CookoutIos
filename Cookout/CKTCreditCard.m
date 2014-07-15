//
//  CKTCreditCard.m
//  Cookout
//
//  Created by Chandrashekar Raghavan on 7/14/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import "CKTCreditCard.h"

@implementation CKTCreditCard

-(instancetype) init
{
    self = [super init];
    
    if(self) {
        self.cardMinLength = -1;
        self.cardMaxLength = -1;
        self.ccType = kInvalid;
    }
    
    return self;
}
@end
