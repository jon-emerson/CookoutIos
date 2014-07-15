//
//  CKTPostOrderDelegate.h
//  Cookout
//
//  Created by Chandrashekar Raghavan on 7/11/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"

@protocol CKTPostOrderDelegate <NSObject>
-(void)orderSucceeded:(NSDictionary *)responseObject;
-(void)orderFailed: (NSError *) error operation:(AFHTTPRequestOperation *) operation;
@end
