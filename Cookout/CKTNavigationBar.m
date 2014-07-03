//
//  CKTNavigationBar.m
//  Cookout
//
//  Created by Jonathan Emerson on 6/26/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import "CKTAppDelegate.h"
#import "CKTDefines.h"
#import "CKTFacebookSessionManager.h"
#import "CKTNavigationBar.h"
#import "CKTDataModel.h"


@interface CKTNavigationBar ()
@property (strong, nonatomic) UIButton *authenticationButton;
@end

@implementation CKTNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Setup the custom bar style for Cookout
        self.barStyle = UIBarStyleBlack;
        self.backgroundColor = UIColorFromRGB(0xED462F);
        self.translucent = NO;
        self.tintColor = [UIColor whiteColor];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    }
    return self;
}

- (void)drawRect:(CGRect)rect
{    

}



@end
