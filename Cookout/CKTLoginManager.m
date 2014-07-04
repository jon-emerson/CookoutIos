//
//  CKTLoginManager.m
//  Cookout
//
//  Created by Chandrashekar Raghavan on 7/2/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import "CKTLoginManager.h"
#import "CKTDataModel.h"

@implementation CKTLoginManager

+ (void)openFBSession:(id) delegate
{
    [FBLoginView class];
    NSLog(@"Opening FB Session in Login Manager");
    
    // if our session has a cached token ready, we open it; note that it is important
    // that we open the session before notification wiring is in place
    
    
    [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          // Handler for session state changes
                                          // This method will be called EACH time the session state changes,
                                          // also for intermediate states and NOT just when the session open
                                          [delegate sessionStateChanged:session state:state error:error];
                                      }];
    

    
    /*if([FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          // Handler for session state changes
                                          // This method will be called EACH time the session state changes,
                                          // also for intermediate states and NOT just when the session open
                                          [delegate sessionStateChanged:session state:state error:error];
                                      }])
    {
                                          
        NSLog(@"Active session tapped");
                            
    }
    else
    {
        
    }*/
    
}


@end
