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

@interface CKTNavigationBar ()
@property (strong, nonatomic) UIButton *authenticationButton;
@end

@implementation CKTNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[CKTFacebookSessionManager sharedFacebookSessionManager] addListener:self];
        
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
    // Add the login button.
    self.authenticationButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.authenticationButton addTarget:self action:@selector(handleLoginRequest:)
                        forControlEvents:UIControlEventTouchUpInside];
    self.authenticationButton.titleLabel.font = [UIFont systemFontOfSize:12];
    self.authenticationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.authenticationButton.frame = CGRectMake(self.bounds.size.width - 100, 7, 90, 30);
    [self handleFacebookSessionStateChange];
    [self addSubview:self.authenticationButton];
}

- (void)handleFacebookSessionStateChange
{
    FBSession *session = [[CKTFacebookSessionManager sharedFacebookSessionManager] session];
    NSLog(@"facebook state change: %u", session.state);

    if (!self.authenticationButton) {
        return;
    }

    if (session.isOpen) {
        [FBRequestConnection startForMeWithCompletionHandler:
                ^(FBRequestConnection *connection, id<FBGraphUser> result, NSError *error) {
                    if (!error) {
                        NSString *helloStr = [NSString stringWithFormat:@"Hi %@!", [result first_name]];
                        [self.authenticationButton setTitle:helloStr forState:UIControlStateNormal];
                    } else {
                        // An error occurred, we need to handle the error
                        // See: https://developers.facebook.com/docs/ios/errors
                        [self.authenticationButton setTitle:@"Login" forState:UIControlStateNormal];
                    }
                }];
    } else {
        [self.authenticationButton setTitle:@"Login" forState:UIControlStateNormal];
    }
}

- (void)handleLoginRequest:(UIButton*)sender
{
    [[CKTFacebookSessionManager sharedFacebookSessionManager] login];
}

@end
