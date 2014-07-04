//
//  CKTSessionHandlerDelegate.h
//  Cookout
//
//  Created by Chandrashekar Raghavan on 7/3/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CKTSessionHandlerDelegate <NSObject>
-(void)sessionRequestResponse:(NSDictionary *)responseObject;
-(void)sessionRequestError:(NSError *)error;
@end
