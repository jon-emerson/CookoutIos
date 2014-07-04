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

@interface CKTCreateAccountViewController ()
@property (weak, nonatomic) IBOutlet FBLoginView *loginView;
@property (weak, nonatomic) IBOutlet UIView *addressEntryView;

@property (weak, nonatomic) IBOutlet UIButton *save;
@property (weak, nonatomic) IBOutlet UITextField *addressLine1;
@property (weak, nonatomic) IBOutlet UITextField *addressLine2;
@property (weak, nonatomic) IBOutlet UITextField *city;
@property (weak, nonatomic) IBOutlet UITextField *state;
@property (weak, nonatomic) IBOutlet UITextField *country;
@property (weak, nonatomic) IBOutlet UITextField *zipcode;
-(IBAction)saveAddress:(id) sender;
@end

@implementation CKTCreateAccountViewController 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"Create account";
        self.loginView.delegate = self;
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

-(void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error
{
    // If a valid session is opened, send the session token to the server and request
    // user credentials
    [CKTServerCommunicator getCKTSession:session.accessTokenData delegate:self];
}

// Handle the request CKT Server's success response to CKT Session Request
-(void)sessionRequestResponse:(NSDictionary *)responseObject;
{
    // Check if the server said success=0 or returned no sessionId
    // If this is the case, then the user doesn't exist yet in the backend
    // and has to be created via createUser call
    NSNumber * didSessionRequestSucceed = [responseObject valueForKey:@"success"];
    CKTDataModel * sharedModel = [CKTDataModel sharedDataModel];
    
    //NSLog(@"%@", [responseObject valueForKey:@"fbUserId"]);

    if(didSessionRequestSucceed)
    {
        // Add the CKT Session Id to CKT User
        CKTUser * u;
        
        if(![sharedModel getUser])
        {
            u = [[CKTUser alloc]init];
            [sharedModel addUser:u];
        }
        u = [sharedModel getUser];
        
        u.sessionId = [responseObject valueForKey:@"sessionId"];
        NSLog(@"Session ID is %@",u.sessionId);
        
        // Check if delivery address is available in the user object
        if(!u.addresses)
        {
            // Addresses aren't already setup in the user object
            // Show the address entry screen to the user
            self.addressEntryView.hidden = NO;
        }
        else
        {
            // Addresses are setup. We should pop this view controller
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    
    // The user doesn't exist on the server. Need to send a createUser
    // request.
    else
    {
        [CKTServerCommunicator createUser:[sharedModel getUser]];
    }
    
    // Proceed to final checkout
}

-(IBAction)saveAddress:(id) sender
{
    // Validate the address fields entered by the user
    // TODO: some validations
    
    // Save address to the local data model
    CKTDataModel * sharedModel = [CKTDataModel sharedDataModel];
    CKTAddress * address = [[CKTAddress alloc] init];
    address.addressLine1 = self.addressLine1.text;
    address.addressLine2 = self.addressLine2.text;
    address.city = self.city.text;
    address.state = self.state.text;
    address.country = self.country.text;
    address.zipcode = self.zipcode.text;
    address.unit = @"-1";
    [sharedModel.getUser.addresses addObject:address];
    
    NSLog(@"Dispatching save address call");
    // Save address to the server
    [CKTServerCommunicator setUserAddress:address user:[sharedModel getUser] delegate:self];
}

// Handle the request CKT Server's error response to CKT Session Request
-(void)sessionRequestError:(NSError *)error
{
    // Address did not save correctly
    // TODO: show error to user and return to view
    
}

-(void)addressSaved:(NSDictionary *)responseObject
{
    // The user's address was saved succesfully.
    // This means the user has a cookout session and a delivery address
    // Pop this view of the stack and go back to the checkout screen
    NSNumber * didSessionRequestSucceed = [responseObject valueForKey:@"success"];
    if(didSessionRequestSucceed)
        [self.navigationController popViewControllerAnimated:YES];
}
-(void)addressSaveFailed:(NSError *)error
{
    
}

- (void)viewDidAppear:(BOOL)animated
{
    // Check if there is an active FB session and if so
    // Do this after didAppear so that the async response handler can respond
    // and push new views on to the nav controller (it's unsafe to push or pop
    // view controllers until viewDidAppear).
    [CKTLoginManager openFBSession:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
