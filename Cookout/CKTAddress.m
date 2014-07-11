//
//  CKTAddress.m
//  Cookout
//  Model for user's address
//  Created by Chandrashekar Raghavan on 7/2/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import "CKTAddress.h"

@implementation CKTAddress

-(NSString *) description
{
    NSMutableString * address = [[NSMutableString alloc] initWithFormat:@"%@ %@, %@, %@ %@",
                                 _addressLine1, _addressLine2,_city,_state,_zipCode];
    return address;
}
@end
