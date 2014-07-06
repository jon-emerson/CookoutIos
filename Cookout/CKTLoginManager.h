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

@interface CKTLoginManager : NSObject <CKTFacebookSessionListener>
+(instancetype)sharedLoginManager;
-(void)startFBSession;
-(void)handleFacebookSessionStateChange;
-(void)startFBSessionWithLoginUI;
-(BOOL)isFacebookSessionOpen;
@end
