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
#import "CKTGMapsAddressEntryViewController.h"
#import "SemiModalAnimatedTransition.h"
#import "CKTServerCommunicator.h"

@interface CKTCheckoutViewController ()

@property (nonatomic, weak) IBOutlet UILabel *orderQuantity;
@property (nonatomic, weak) IBOutlet UILabel *totalPrice;
@property (weak, nonatomic) IBOutlet CKTAsyncImageView *foodImage;
@property (nonatomic, weak) IBOutlet UILabel *foodLabel;
@property (nonatomic, weak) IBOutlet UIButton *placeOrder;
@property (nonatomic, weak) IBOutlet UITextField *streetAddress;
@property (nonatomic, weak) IBOutlet UITextField *unitNumber;
@property (nonatomic, weak) IBOutlet UITextField *creditCard;
@property (nonatomic) UITextField *activeField;

-(IBAction)placeOrderAction:(id) sender;
-(IBAction)openGmaps:(id) sender;
@property (weak, nonatomic) IBOutlet UIButton *triggerGmaps;

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
    // OMG time to place the order!
    ((CKTAddress *)[CKTCurrentUser sharedInstance].addresses[self.selectedAddressIndex]).unit
                                                                = self.unitNumber.text;
    if([self isValidUser] && [self hasValidDeliveryAddress] && [self hasValidCCInfo])
    {
        [CKTServerCommunicator placeOrder:self.order addressIndex:self.selectedAddressIndex delegate:self];
    }
    else NSLog(@"Something wasn't setup right");
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.streetAddress.delegate = self;
    self.unitNumber.delegate = self;
    self.creditCard.delegate = self;
    
    // Do any additional setup after loading the view from its nib.
    // Display order summary
    self.orderQuantity.text = [[NSString alloc] initWithFormat:@"%@ x", self.order.orderQuantity.stringValue];
    self.foodImage.imageURL = [self.order.dinner imageNSUrl];
    self.totalPrice.text = [[NSString alloc] initWithFormat:@"$%.2f",
                            ([self.order.dinner.price floatValue] * [self.order.orderQuantity floatValue])];
    self.foodLabel.text = [self.order.dinner name];
    
    [self.creditCard setLeftViewMode:UITextFieldViewModeAlways];
    self.creditCard.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cc.png"]];
    self.creditCard.alpha = 0.6;
    
    
    // By default pick the first address.
    // TODO: replace with more intelligence
    if([CKTCurrentUser sharedInstance].addresses.count >0)
    {
        self.selectedAddressIndex = 0;
        self.streetAddress.text = [[CKTCurrentUser sharedInstance].addresses[self.selectedAddressIndex] description];
        self.unitNumber.text = ((CKTAddress *)[CKTCurrentUser sharedInstance].addresses[self.selectedAddressIndex]).unit;
    }
    
    
    
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
            // All is well don't have to do anything
            
        } else {
            // Ascertain what exactly is missing and open to that view
            if(![self hasValidDeliveryAddress])
            {
                // Modally load the Gmaps based address entry view
                /*CKTGMapsAddressEntryViewController * addressEntry = [[CKTGMapsAddressEntryViewController alloc]init];
                self.definesPresentationContext = YES;
                self.providesPresentationContextTransitionStyle = YES;
                self.modalPresentationStyle = UIModalPresentationFormSheet;
                
                [addressEntry.view setBackgroundColor:[[UIColor clearColor] colorWithAlphaComponent:0.5]];

                [self presentViewController:addressEntry animated:YES completion:^(void) {
                   // Do something after address entry comes back
                }];*/
                
            }
            if([self hasValidDeliveryAddress] && ![self hasValidCCInfo])
            {
                // Modally load the credit card info view directly
                
            }
            
        }
    } else {
        // Modally load the Facebook sign in prompt
        CKTCreateAccountViewController * createAccount = [[CKTCreateAccountViewController alloc]init];

        [createAccount.view setBackgroundColor:[[UIColor clearColor] colorWithAlphaComponent:0.8]];
        createAccount.modalPresentationStyle = UIModalPresentationCustom;
        createAccount.transitioningDelegate = self;
        createAccount.saveButton.hidden = true;
        createAccount.name.hidden = true;
        createAccount.email.hidden = true;
        createAccount.phone.hidden = true;
        
        [self presentViewController:createAccount animated:YES completion:^(void) {
            // Do something after Facebook sign in comes back
        }];
    }
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    SemiModalAnimatedTransition *semiModalAnimatedTransition = [[SemiModalAnimatedTransition alloc] init];
    semiModalAnimatedTransition.presenting = YES;
    return semiModalAnimatedTransition;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    SemiModalAnimatedTransition *semiModalAnimatedTransition = [[SemiModalAnimatedTransition alloc] init];
    return semiModalAnimatedTransition;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    self.activeField = textField;
    [(UIScrollView *)self.view setContentOffset:CGPointMake(0,textField.center.y-60) animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeField = nil;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    if(textField.tag == 10)
    {
        // The user touched the address field - bring up the Gmaps view
        CKTGMapsAddressEntryViewController * addressEntry = [[CKTGMapsAddressEntryViewController alloc]init];
        addressEntry.modalPresentationStyle = UIModalPresentationCustom;
        addressEntry.transitioningDelegate = self;
        addressEntry.delegate = self;
        [addressEntry.view setBackgroundColor:[[UIColor clearColor] colorWithAlphaComponent:0.8]];
        
        [self presentViewController:addressEntry animated:YES completion:^(void) {
            // Do something after address entry comes back
        }];
        return NO;
    }
    else return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)addressUpdated: (int) selectedIndex
{
    self.streetAddress.text = [[CKTCurrentUser sharedInstance].addresses[selectedIndex] description];
}

- (IBAction)doOnboarding:(id)sender
{
    // Onboard the user
    CKTCreateAccountViewController *createAccount =
            [[CKTCreateAccountViewController alloc] init];
    createAccount.order = self.order;
    [self.navigationController pushViewController:createAccount animated:YES];
}

- (BOOL)isValidUser
{
    // See if user is signed in - if not prompt sign in
    NSLog(@"isValidUser session id %@", CKTDataModel.sharedDataModel.currentUser.sessionId);
    return !!CKTDataModel.sharedDataModel.currentUser.sessionId;
}

- (BOOL)hasValidDeliveryAddress
{
    return !![CKTDataModel.sharedDataModel.currentUser.addresses count];
}

- (BOOL)hasValidCCInfo
{
    // Check for credit card info on the server
    return YES;
}
-(IBAction)openGmaps:(id) sender
{
    CKTGMapsAddressEntryViewController * aEntry = [[CKTGMapsAddressEntryViewController alloc]init];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [self.navigationController pushViewController:aEntry animated:YES];
}
@end
