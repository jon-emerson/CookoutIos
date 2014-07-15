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
@end

@implementation CKTCheckoutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"Place order";
        self.selectedCard = [[CKTCreditCard alloc]init];        
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

-(void)orderSucceeded:(NSDictionary *)responseObject
{
    UIAlertView * newAlert = [[UIAlertView alloc]init];
    // Once order succeeds, refresh user state
    [CKTServerCommunicator syncDataModel];
    newAlert.message = @"Yaay! Order placed - You will receive it soon!";
    [newAlert addButtonWithTitle:@"Ok"];
    [newAlert show];
}

-(void)orderFailed: (NSError *) error operation:(AFHTTPRequestOperation *) operation
{
    UIAlertView * newAlert = [[UIAlertView alloc]init];
    newAlert.message = @"Oops there was a problem completing your order :(";
    [newAlert addButtonWithTitle:@"Ok"];
    [newAlert show];
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
    
    if ([self isValidUser])
    {
        // User is signed in - yaay!
        if ([self hasValidDeliveryAddress] && [self hasValidCCInfo])
        {
            // All is well don't have to do anything
            
        }
    }
    else
    {
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

- (BOOL) isLuhnValid: (NSString *) ccNumber
{
    // Validate the entered number using the Luhn algorithm
    NSString *sansChecksum = [ccNumber substringWithRange:NSMakeRange(0, ccNumber.length-1)];
    int lastDigit = [[ccNumber substringFromIndex:ccNumber.length-1] intValue];
    int startIndex = 0;
    int runningTotal = 0;
    int nextDigit = 0;
    
    BOOL isValid = NO;
    
    if(sansChecksum.length%2 == 0)
    {
        // Start from the second character
        startIndex = 1;
    }
    
    // Multiply odd digits by 2, and subtract 9 if result > 10
    for(int i=startIndex;i<sansChecksum.length;i++)
    {
        nextDigit = [[ccNumber substringWithRange:NSMakeRange(i, 1)] intValue];
        
        // Even number of digits, start at second position (index=1) and
        // go through odd numbers
        if(startIndex == 1)
        {
            if(i%2 == 1)
            {
                nextDigit *=2;
                if(nextDigit>9) nextDigit-=9;
                    runningTotal += nextDigit;
            }
            else runningTotal+=nextDigit;
        }
        else
        {
            if(i%2 == 0)
            {
                nextDigit *=2;
                if(nextDigit>9) nextDigit-=9;
                runningTotal += nextDigit;
            }
            else runningTotal+=nextDigit;
        }
    }
    if((runningTotal%10 == lastDigit) || (runningTotal+lastDigit)%10 == 0) isValid = YES;
    return isValid;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
                                                replacementString:(NSString *)string
{
    
    // Handle the entry of credit card numbers
    NSMutableString *updatedCCString =[[NSMutableString alloc]init];
    
    // Get updated string
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    // Tokenize to remove separators - anything that's not a number is a tokenizer
    NSArray *components = [newString componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
    
    // Rejoin it to get the full string
    NSString *ccString = [components componentsJoinedByString:@""];
    
    // Look at the length of the string
    int length = ccString.length;
    
    // Check credit card type
    switch (length)
    {
        case 1: {
            char firstDigit = [ccString characterAtIndex:0];
            // If the first character isn't 3,5,6 or 4, this is not a valid CC number
            if(firstDigit!='3' && firstDigit!='5' && firstDigit!='6' && firstDigit!= '4')
            {
                return NO;
            }
            else if (firstDigit == '4')
            {
                // Visa card
                self.selectedCard.ccType= kVisa;
                self.selectedCard.cardMinLength=13;
                self.selectedCard.cardMaxLength=16;
            }
            [updatedCCString appendFormat:@"%c",firstDigit];
            break;
        }
        case 2: {
            if([ccString isEqualToString:@"34"] || [ccString isEqualToString:@"37"])
            {
                // Amex card
                self.selectedCard.ccType=kAmex;
                self.selectedCard.cardMinLength=15;
                self.selectedCard.cardMaxLength=15;
            }
            if([ccString isEqualToString:@"36"])
            {
                // Diners club international
                self.selectedCard.ccType=kDiners;
                self.selectedCard.cardMinLength=14;
                self.selectedCard.cardMaxLength=14;
            }
            if([ccString isEqualToString:@"51"] || [ccString isEqualToString:@"52"] || [ccString isEqualToString:@"53"] || [ccString isEqualToString:@"54"] || [ccString isEqualToString:@"55"])
            {
                // Master Card
                self.selectedCard.ccType=kMaster;
                self.selectedCard.cardMinLength=16;
                self.selectedCard.cardMaxLength=19;
            }
            if([ccString isEqualToString:@"54"])
            {
                // Diners club international
                self.selectedCard.ccType=kDiners;
                self.selectedCard.cardMinLength=14;
                self.selectedCard.cardMaxLength=14;
            }
            [updatedCCString appendString:newString];
            break;
        }
        case 4: case 8: case 12:
        {
            // Include a space at the end of 4 characters if this is
            // a visa, master, discover, diners club
            if(self.selectedCard.ccType == kVisa || self.selectedCard.ccType == kMaster || self.selectedCard.ccType == kDiners || self.selectedCard.ccType == kDiscover)
            {
                [updatedCCString appendString:newString];
                [updatedCCString appendString:@" "];
            }
            break;
        }
        case 10:
        {
            // Include a space for Amex
            if(self.selectedCard.ccType == kAmex)
            {
                [updatedCCString appendString:newString];
                [updatedCCString appendString:@" "];
            }
            else
                [updatedCCString appendString:newString];
            break;
        }
        case 13: case 14: case 16:
        {
            // If selected card type is visa, this maybe a valid number
            if(self.selectedCard.ccType == kVisa && [self isLuhnValid:ccString])
            {
                // Switch over date, CVV entry mode
                [updatedCCString appendString:newString];
                UIAlertView * newAlert = [[UIAlertView alloc]init];
                newAlert.message = @"Valid 13 digit visa number entered";
                [newAlert addButtonWithTitle:@"Ok"];
                [newAlert show];
            }
            // If not wait for more digits
            break;
        }
        case 15:
        {
            // If selected card is Amex, this maybe a valid number
            if(self.selectedCard.ccType == kAmex)
            {
                if([self isLuhnValid:ccString])
                {
                    // Switch over date, CVV entry mode
                    [updatedCCString appendString:newString];
                    UIAlertView * newAlert = [[UIAlertView alloc]init];
                    newAlert.message = @"Valid AMEX number entered";
                    [newAlert addButtonWithTitle:@"Ok"];
                    [newAlert show];
                }
                else
                {
                    // Invalid AMEX number
                    [updatedCCString appendString:newString];
                    [self showBadCCBar];
                }
            }
        }
        default:
            [updatedCCString appendString:newString];
     }
    
    textField.text = updatedCCString;
    // Don't allow unformatted input in the text box
    return NO;
    
}

-(void) showBadCCBar
{
    
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
