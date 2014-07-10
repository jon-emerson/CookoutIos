//
//  CKTCheckoutViewController.h
//  Cookout
//
//  Created by Chandrashekar Raghavan on 7/1/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKTOrder.h"
#import "CKTDataModel.h"
#import "CKTFacebookSessionManager.h"
#import "CKTAddressSaveHandler.h"
#import "CKTUser.h"

@interface CKTCheckoutViewController : UIViewController <CKTFacebookSessionListener,
CKTAddressSaveHandler>
@property (nonatomic, strong) CKTOrder *order;

@end
