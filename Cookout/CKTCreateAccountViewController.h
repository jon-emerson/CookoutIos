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
#import "CKTCreateUserHandler.h"

@interface CKTCreateAccountViewController : UIViewController
        <CKTFacebookSessionListener,CKTAddressSaveHandler, CKTCreateUserHandler,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UILabel *guideText;
@property (weak, nonatomic) CKTOrder *order;
-(BOOL) isValidEmailAddress:(NSString *) email;

@end
