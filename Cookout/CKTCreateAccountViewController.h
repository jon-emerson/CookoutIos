//
//  CKTCreateAccountViewController.h
//  Cookout
//
//  Created by Chandrashekar Raghavan on 7/2/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "CKTAddressCCEntryViewController.h"
#import "CKTOrder.h"

@interface CKTCreateAccountViewController : UIViewController <FBLoginViewDelegate>
@property (weak, nonatomic) CKTOrder * order;
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView;
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user;
@end
