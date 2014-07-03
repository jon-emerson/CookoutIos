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
@property (nonatomic, weak) IBOutlet UILabel * orderQuantity;
@property (nonatomic, weak) IBOutlet UILabel * totalPrice;
@property (weak, nonatomic) IBOutlet CKTAsyncImageView *foodImage;
@property (nonatomic, weak) IBOutlet UILabel * foodLabel;
@property (nonatomic, weak) IBOutlet UIView * needsOnboarding;
@end

@implementation CKTCheckoutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"Place Order";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.needsOnboarding.hidden = NO;
    [self.needsOnboarding setNeedsDisplay];
    // Do any additional setup after loading the view from its nib.
    // Display order summary
    self.orderQuantity.text = [[NSString alloc] initWithFormat:@"%@ x", self.order.orderQuantity.stringValue];
    self.foodImage.imageURL = [self.order.dinner imageUrl];
    self.totalPrice.text = [[NSString alloc] initWithFormat:@"$%.2f", ([self.order.dinner.price floatValue]*[self.order.orderQuantity floatValue])];
    self.foodLabel.text = [self.order.dinner name];
    
    
    // Handle autolayout messiness and allow scrolling - create a subview of UIScrollView that
    // contains all the UI elements. (done in XIB). Retrieve parent scroll view
    UIScrollView * scrollView = self.view;
    
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
        if([self hasValidDeliveryAddress] && [self hasValidCCInfo])
        {
            // Setup checkout
        }
        else
        {
             self.needsOnboarding.hidden = NO;
        }
    }
    else
    {
        // Get user to sign in using FB
        self.needsOnboarding.hidden = NO;
        
    }
    
    
    // If signed in, check if delivery address and credit card information
    // are available for the user. If not prompt entry of address and CC
    
}

- (IBAction)doOnboarding: (id) sender
{
    // Onboard the user
    CKTCreateAccountViewController * createAccount = [[CKTCreateAccountViewController alloc]init];
    createAccount.order = self.order;
    [self.navigationController pushViewController:createAccount animated:YES];
    
}


- (BOOL)isValidUser
{
    // See if user is signed in - if not prompt sign in
    NSObject * user = [[CKTDataModel sharedDataModel] getUser];
    if(user)
    {
        return YES;
    }
    return NO;
}

- (BOOL)hasValidDeliveryAddress
{
    if(self.order.user.deliveryAddress)
    {
        return YES;
    }
    return NO;
}

- (BOOL)hasValidCCInfo
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
