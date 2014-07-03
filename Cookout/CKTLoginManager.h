//
//  CKTLoginManager.h
//  Cookout
//
//  Class for handling Login
//  Created by Chandrashekar Raghavan on 7/2/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKTFacebookSessionManager.h"

@interface CKTLoginManager : NSObject
+ (void)sessionStateChanged:session state:(FBSessionState)state error:(NSError *)error;
+ (void)openFBSession;
@end
