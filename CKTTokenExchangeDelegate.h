//
//  CKTTokenExchangeDelegate.h
//  Cookout
//
//  Created by Chandrashekar Raghavan on 7/11/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CKTTokenExchangeDelegate <NSObject>
-(void)exchangeSucceeded:(NSDictionary *) response;
-(void)exchangeFailed:(NSError *) error operation:(AFHTTPRequestOperation *) operation;
@end
