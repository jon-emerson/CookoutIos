//
//  CKTCreateAccountViewController.h
//  Cookout
//
//  Created by Chandrashekar Raghavan on 7/2/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import <UIKit/UIKit.h>

#import "CKTAddressSaveHandler.h"
#import "CKTFacebookSessionListener.h"
#import "CKTOrder.h"
#import "CKTSessionHandlerDelegate.h"

@interface CKTCreateAccountViewController : UIViewController
        <CKTFacebookSessionListener, CKTSessionHandlerDelegate,
                CKTAddressSaveHandler>

@property (weak, nonatomic) CKTOrder *order;

- (void)handleFacebookSessionStateChange;

@end
