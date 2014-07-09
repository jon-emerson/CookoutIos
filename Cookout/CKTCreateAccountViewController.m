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
@property (weak, nonatomic) IBOutlet UIView *addressEntryView;
@property (weak, nonatomic) IBOutlet UIView *loginSection;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (weak, nonatomic) IBOutlet UIButton *save;
@property (weak, nonatomic) IBOutlet UITextField *addressLine1;
@property (weak, nonatomic) IBOutlet UITextField *addressLine2;
@property (weak, nonatomic) IBOutlet UITextField *city;
@property (weak, nonatomic) IBOutlet UITextField *state;
@property (weak, nonatomic) IBOutlet UITextField *country;
@property (weak, nonatomic) IBOutlet UITextField *zipcode;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
-(IBAction)saveAddress:(id) sender;
-(IBAction)doFacebookLogin:(id) sender;

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


- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {


}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

/*-(void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error
{
    // If a valid session is opened, send the session token to the server and request
    // user credentials
    [CKTServerCommunicator getCKTSession:session.accessTokenData delegate:self];
}*/

// Handle the request CKT Server's success response to CKT Session Request
- (void)sessionRequestResponse:(NSDictionary *)responseObject;
{
    // Check if the server said success=0 or returned no sessionId
    // If this is the case, then the user doesn't exist yet in the backend
    // and has to be created via createUser call
    NSNumber *didSessionRequestSucceed = [responseObject valueForKey:@"success"];
    NSLog(@"VALUE OF dis sesso%@", didSessionRequestSucceed);
    CKTDataModel *sharedModel = [CKTDataModel sharedDataModel];
    
    //NSLog(@"%@", [responseObject valueForKey:@"fbUserId"]);

    if (didSessionRequestSucceed) {
        // Add the CKT Session Id to CKT User
        CKTCurrentUser *u;
        
        if (!sharedModel.currentUser) {
            u = [[CKTCurrentUser alloc] init];
            sharedModel.currentUser = u;
        }
        u = sharedModel.currentUser;

        u.sessionId = [responseObject valueForKey:@"sessionId"];
        NSLog(@"Session ID is %@", u.sessionId);
        
        // Check if delivery address is available in the user object
        if (!u.addresses) {
            // Addresses aren't already setup in the user object
            // Show the address entry screen to the user
            self.addressEntryView.hidden = NO;
        } else {
            // Addresses are setup. We should pop this view controller
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        // The user doesn't exist on the server. Need to send a createUser
        // request.
        [CKTServerCommunicator createCurrentUser:sharedModel.currentUser];
    }
    
    // Proceed to final checkout
}

- (void)handleFacebookSessionStateChange
{
    // Facebook session state changed. I may have to change onscreen items
    if (FBSession.activeSession.state == FBSessionStateOpen ||
            FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        // Remove Facebook login section from screen
        self.loginSection.hidden = true;
        
        // Check if the user has an address setup
        if (CKTDataModel.sharedDataModel.currentUser.addresses) {
            // My work here is done
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            // Show the address entry interface
            self.addressEntryView.hidden = false;
        }
    } else {
        self.loginSection.hidden = false;
        self.addressEntryView.hidden = true;
    }
}

- (IBAction)saveAddress:(id)sender
{
    // Validate the address fields entered by the user
    // TODO: some validations
    
    // Save address to the local data model
    CKTDataModel *sharedModel = [CKTDataModel sharedDataModel];
    CKTAddress *address = [[CKTAddress alloc] init];
    address.addressLine1 = self.addressLine1.text;
    address.addressLine2 = self.addressLine2.text;
    address.city = self.city.text;
    address.state = self.state.text;
    address.country = self.country.text;
    address.zipCode = self.zipcode.text;
    address.unit = @"1";
    [sharedModel addAddress:address];
    
    NSLog(@"Dispatching save address call");
    
    self.spinner.hidden = false;
    [self.spinner startAnimating];
    
    // Save address to the server.
    [CKTServerCommunicator setUserAddress:address
                              currentUser:sharedModel.currentUser
                                 delegate:self];
}

- (IBAction)doFacebookLogin:(id)sender
{
    // Do facebook login
    [[CKTLoginManager sharedLoginManager] startFBSessionWithLoginUI];
}


- (void)addressSaved:(NSDictionary *)responseObject
{
    // The user's address was saved succesfully.
    // This means the user has a cookout session and a delivery address
    // Pop this view of the stack and go back to the checkout screen
    NSString *didSessionRequestSucceed = [responseObject valueForKey:@"success"];
    if (didSessionRequestSucceed.intValue == 1) {
        // the address was saved successfully. Remove the spinner and pop the view
        [self.spinner stopAnimating];
        self.spinner.hidden = true;
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        // The address save did not succeed due to a problem with the address the user
        // entered. Display an appropriate error message and keep the user on the address
        // entry view.
        [self.spinner stopAnimating];
        self.spinner.hidden = true;
        UIAlertView * newAlert = [[UIAlertView alloc]init];
        newAlert.message = @"There was a problem saving your address. Please try again.";
        newAlert.cancelButtonIndex = 0;
        [newAlert show];
        
    }
}
- (void)addressSaveFailed:(NSError *)error operation:(AFHTTPRequestOperation *)operation
{
    // The address save did not succeed due to server error. Display an error message and
    // keep the user on the address entry view.
    self.spinner.hidden = true;
    [self.spinner stopAnimating];
    UIAlertView * newAlert = [[UIAlertView alloc]init];
    newAlert.message = @"There was a problem saving your address. Please try again.";
    [newAlert addButtonWithTitle:@"Ok"];
    [newAlert show];
}

- (void)viewDidAppear:(BOOL)animated
{
    // Check if there is an active CKT session
    CKTDataModel *sharedModel = [CKTDataModel sharedDataModel];
    if (sharedModel.currentUser.sessionId) {
        // Check if user already has an address
        NSLog(@"valid");
        if (sharedModel.currentUser.addresses) {
            // My work here is done
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            // Show the address entry interface
            self.addressEntryView.hidden = NO;
        }
    } else {
        // No valid cookout session. Check if there is already a Facebook session
        if ([[CKTLoginManager sharedLoginManager] isFacebookSessionOpen]) {
            // Ok the user has already signed and authorized CKT for FB
            // Issue a create user call to the CKT server
            
            self.loginSection.hidden = YES;

            [CKTServerCommunicator createCurrentUser:sharedModel.currentUser];
           
            if (sharedModel.currentUser.addresses) {
                // User address already setup!
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                // Prompt address entry
                self.addressEntryView.hidden = NO;
                self.loginSection.hidden = YES;
            }
        } else {
            // Prompt Facebook sign in
            self.addressEntryView.hidden = YES;
            self.loginSection.hidden = NO;
        }
    }
}


@end
