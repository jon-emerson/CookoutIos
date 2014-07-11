//
//  CKTCreateAccountViewController.m
//  Cookout
//
//  Created by Chandrashekar Raghavan on 7/2/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import "CKTCreateAccountViewController.h"
#import "CKTLoginManager.h"
#import "CKTServerCommunicator.h"
#import "CKTDataModel.h"
#include "CKTFacebookSessionListener.h"
#include "CKTGMapsAddressEntryViewController.h"

@interface CKTCreateAccountViewController ()
-(IBAction)doFacebookLogin:(id) sender;
-(IBAction)saveUserDetails:(id) sender;
@end

@implementation CKTCreateAccountViewController 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"Create account";
        // Register myself as a listener for FB login events
        [[CKTFacebookSessionManager sharedFacebookSessionManager]addListener:self];
    }
    return self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSArray *components = [newString componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
    NSString *decimalString = [components componentsJoinedByString:@""];
    
    NSUInteger length = decimalString.length;
    BOOL hasLeadingOne = length > 0 && [decimalString characterAtIndex:0] == '1';
    
    if (length == 0 || (length > 10 && !hasLeadingOne) || (length > 11)) {
        textField.text = decimalString;
        return NO;
    }
    
    NSUInteger index = 0;
    NSMutableString *formattedString = [NSMutableString string];
    
    if (hasLeadingOne) {
        [formattedString appendString:@"1 "];
        index += 1;
    }
    
    if (length - index > 3) {
        NSString *areaCode = [decimalString substringWithRange:NSMakeRange(index, 3)];
        [formattedString appendFormat:@"(%@) ",areaCode];
        index += 3;
    }
    
    if (length - index > 3) {
        NSString *prefix = [decimalString substringWithRange:NSMakeRange(index, 3)];
        [formattedString appendFormat:@"%@-",prefix];
        index += 3;
    }
    
    NSString *remainder = [decimalString substringFromIndex:index];
    [formattedString appendString:remainder];
    
    textField.text = formattedString;
    
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)handleFacebookSessionStateChange
{
    // Facebook session state changed. I may have to change onscreen items
    if ([[CKTLoginManager sharedLoginManager] isFacebookSessionOpen])
    {
        // A valid FB session is available, the login manager may have tried token exchange
        // Check for valid token
        NSLog(@"Handling in CKTCREATEACCOUNT");

        CKTDataModel *sharedModel = [CKTDataModel sharedDataModel];
        if (!sharedModel.currentUser.sessionId)
        {
            // TODO: Call exchange token here instead
            
            
            // Confirm user details. Email and Name are mandatory
            self.saveButton.hidden = false;
            self.name.hidden = false;
            self.email.hidden = false;
            self.phone.hidden = false;
            
            self.loginButton.hidden = true;
            self.guideText.hidden = true;
        
            if([CKTCurrentUser sharedInstance].name)
                self.name.text = [CKTCurrentUser sharedInstance].name;
            if([CKTCurrentUser sharedInstance].email)
                self.email.text = [CKTCurrentUser sharedInstance].email;
        }
        
    }
}
- (IBAction)doFacebookLogin:(id)sender
{
    // Do facebook login
    [[CKTLoginManager sharedLoginManager] startFBSessionWithLoginUI];
}

-(IBAction)saveUserDetails:(id) sender
{
    // Ok the user has already signed and authorized CKT for FB
    // Validate text fields
    if([self.name.text length]==0 || [self.email.text length] == 0 ||
       ![self isValidEmailAddress:self.email.text] || (self.phone.text.length < 14))
    {
        // Prompt the user to put in valid shit yo
        UIAlertView * newAlert = [[UIAlertView alloc]init];
        newAlert.message = @"Please enter a valid name & email address";
        [newAlert addButtonWithTitle:@"Ok"];
        [newAlert show];
        return;
    }
    
    // Update currentUser with name and email from form
    [CKTCurrentUser sharedInstance].name = self.name.text;
    [CKTCurrentUser sharedInstance].email = self.email.text;
    [CKTCurrentUser sharedInstance].phoneNumber = self.phone.text;
    
    // Issue a create user call to the CKT server
    [CKTServerCommunicator createCurrentUser:self];
}

-(BOOL) isValidEmailAddress:(NSString *) email
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.phone.delegate = self;
    self.saveButton.hidden = true;
    self.name.hidden = true;
    self.email.hidden = true;
    self.phone.hidden = true;
    
    self.loginButton.hidden = false;
    self.guideText.hidden = false;
    
    // Check if there is an active CKT session
    CKTDataModel *sharedModel = [CKTDataModel sharedDataModel];
    if (sharedModel.currentUser.sessionId) {
        // The user is logged in, my work is done. time to pop pop
        NSLog(@"valid");
        [self dismissViewControllerAnimated:TRUE completion:NULL];
    }
    else
    {
        // No valid cookout session. Check if there is already a Facebook session
        if ([[CKTLoginManager sharedLoginManager] isFacebookSessionOpen]) {
            // Confirm user details. Email and Name are mandatory
            self.saveButton.hidden = false;
            self.name.hidden = false;
            self.email.hidden = false;
            self.phone.hidden = false;
            
            self.loginButton.hidden = true;
            self.guideText.hidden = true;

            self.name.text = [CKTCurrentUser sharedInstance].name;
            self.email.text = [CKTCurrentUser sharedInstance].email;
        }
    }
}

-(void)createUserSucceeded:(NSDictionary *) response
{
    // Ok user created, session setup, exit stage left
    [self dismissViewControllerAnimated:TRUE completion:NULL];
}

-(void)createUserFailed:(NSError *) error operation:(AFHTTPRequestOperation *) operation
{
    // The request may have failed, but that might be because
    // a valid session already exists
    if([operation.responseObject objectForKey:@"sessionId"])
    {
        // All good, time to go - but setup the sessionId first
        [[CKTCurrentUser sharedInstance] setSessionId:[operation.responseObject valueForKey:@"sessionId"]];
        [self dismissViewControllerAnimated:TRUE completion:NULL];
    }
    
    // If not show an error message and pop the view in an error state
    else
    {
        UIAlertView * newAlert = [[UIAlertView alloc]init];
        newAlert.title = @"Oops :(";
        newAlert.message = @"We had problems creating your account. We're working hard to fix it - try again in a few minutes, pretty please?";
        [newAlert addButtonWithTitle:@"Ok"];
        [newAlert show];
    }
}
@end
