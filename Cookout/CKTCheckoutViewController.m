//
//  CKTCheckoutViewController.m
//  Cookout
//
//  Created by Chandrashekar Raghavan on 7/1/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import "CKTCheckoutViewController.h"
#import "CKTAsyncImageView.h"
#import "CKTCreateAccountViewController.h"

@interface CKTCheckoutViewController ()

@property (nonatomic, weak) IBOutlet UILabel *orderQuantity;
@property (nonatomic, weak) IBOutlet UILabel *totalPrice;
@property (weak, nonatomic) IBOutlet CKTAsyncImageView *foodImage;
@property (nonatomic, weak) IBOutlet UILabel *foodLabel;
@property (nonatomic, weak) IBOutlet UIView *needsOnboarding;
@property (nonatomic, weak) IBOutlet UIView *orderConfirmation;
@property (nonatomic, weak) IBOutlet UIButton *placeOrder;
@property (nonatomic, weak) IBOutlet UIPickerView *addressPicker;
-(IBAction)placeOrderAction:(id) sender;

@end

@implementation CKTCheckoutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"Place order";
    }
    return self;
}

- (IBAction)placeOrderAction:(id)sender
{
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Do any additional setup after loading the view from its nib.
    // Display order summary
    self.orderQuantity.text = [[NSString alloc] initWithFormat:@"%@ x", self.order.orderQuantity.stringValue];
    self.foodImage.imageURL = [self.order.dinner imageNSUrl];
    self.totalPrice.text = [[NSString alloc] initWithFormat:@"$%.2f",
                            ([self.order.dinner.price floatValue] * [self.order.orderQuantity floatValue])];
    self.foodLabel.text = [self.order.dinner name];
    
    
    // Handle autolayout messiness and allow scrolling - create a subview of UIScrollView that
    // contains all the UI elements. (done in XIB). Retrieve parent scroll view
    UIScrollView *scrollView = (UIScrollView *)self.view;
    
    // Retrieve the child UIView that contains all the UI elements
    UIView *child = scrollView.subviews[0];
    
    // Setup an autolayout constraint that makes the bottom of the scroll view
    // equal to the bottom of the child UI view. This will size the scroll view correctly
    // and make the view scrollable
    [scrollView addConstraint:[NSLayoutConstraint constraintWithItem:child
                                                           attribute:NSLayoutAttributeBottom
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:scrollView
                                                           attribute:NSLayoutAttributeBottom
                                                          multiplier:1.0
                                                            constant:0.0]];

    if ([self isValidUser]) {
        // User is signed in - yaay!
        if ([self hasValidDeliveryAddress] && [self hasValidCCInfo]) {
            // Setup checkout
            self.needsOnboarding.hidden = YES;
            self.orderConfirmation.hidden = NO;
        } else {
             // Uh-oh no valid CC or address - open the door to onboarding ville.
            self.needsOnboarding.hidden = NO;
            self.orderConfirmation.hidden = YES;
        }
    } else {
        // Get user to sign in using FB
        self.needsOnboarding.hidden = NO;
        self.orderConfirmation.hidden = YES;
    }
}

- (IBAction)doOnboarding:(id)sender
{
    // Onboard the user
    CKTCreateAccountViewController *createAccount = [[CKTCreateAccountViewController alloc] init];
    createAccount.order = self.order;
    [self.navigationController pushViewController:createAccount animated:YES];
}

- (BOOL)isValidUser
{
    // See if user is signed in - if not prompt sign in
    NSLog(@"isValidUser session id %@", CKTDataModel.sharedDataModel.getUser.sessionId);
    return !!CKTDataModel.sharedDataModel.getUser.sessionId;
}

- (BOOL)hasValidDeliveryAddress
{
    return !![CKTDataModel.sharedDataModel.getUser.addresses count];
}

- (BOOL)hasValidCCInfo
{
    return YES;
}

@end
