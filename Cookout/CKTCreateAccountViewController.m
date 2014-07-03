//
//  CKTCreateAccountViewController.m
//  Cookout
//
//  Created by Chandrashekar Raghavan on 7/2/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import "CKTCreateAccountViewController.h"

@interface CKTCreateAccountViewController ()
@property (weak, nonatomic) IBOutlet FBLoginView *loginView;

@end

@implementation CKTCreateAccountViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"Create account";
        //self.loginView.delegate = self;
    }
    return self;
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    // The user is logged in. Jump to the next step in the
    // onboarding flow
    /*CKTAddressCCEntryViewController * addressCCSetup = [[CKTAddressCCEntryViewController alloc] init];
    addressCCSetup.order = self.order;
    [self.navigationController pushViewController:addressCCSetup animated:YES];*/
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {


}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.


}
- (void)viewDidAppear:(BOOL)animated
{
    CKTAddressCCEntryViewController * addressCCSetup = [[CKTAddressCCEntryViewController alloc] init];
    addressCCSetup.order = self.order;
    [self.navigationController pushViewController:addressCCSetup animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    NSLog(@"DID RECEIVE MEMORY WARNING");
}

@end
