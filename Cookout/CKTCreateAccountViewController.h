//
//  CKTCreateAccountViewController.h
//  Cookout
//
//  Created by Chandrashekar Raghavan on 7/2/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "CKTOrder.h"
#import "CKTSessionHandlerDelegate.h"
#include "CKTFacebookSessionListener.h"
#import "CKTAddressSaveHandler.h"

@interface CKTCreateAccountViewController : UIViewController <CKTFacebookSessionListener,CKTSessionHandlerDelegate,CKTAddressSaveHandler>
@property (weak, nonatomic) CKTOrder * order;
-(void)handleFacebookSessionStateChange;
@end
