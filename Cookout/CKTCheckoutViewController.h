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
#import "CKTAddressUpdateHandler.h"
#import "CKTUser.h"
#import "CKTPostOrderDelegate.h"
#import "CKTCreditCard.h"


@interface CKTCheckoutViewController : UIViewController <CKTFacebookSessionListener,
CKTAddressUpdateHandler,CKTPostOrderDelegate>
@property (nonatomic, strong) CKTOrder *order;
@property (nonatomic) int selectedAddressIndex;
@property (nonatomic, strong) CKTCreditCard *selectedCard;
- (BOOL) isLuhnValid: (NSString *) ccNumber;
@end
