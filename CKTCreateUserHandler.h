//
//  CKTCreateUserHandler.h
//  Cookout
//
//  Created by Chandrashekar Raghavan on 7/9/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking/AFHTTPRequestOperation.h"

@protocol CKTCreateUserHandler <NSObject>
-(void)createUserSucceeded:(NSDictionary *) response;
-(void)createUserFailed:(NSError *) error operation:(AFHTTPRequestOperation *) operation;
@end
