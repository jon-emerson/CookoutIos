//
//  CKTAddressCCEntryViewController.m
//  Cookout
//
//  Created by Chandrashekar Raghavan on 7/2/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import "CKTAddressCCEntryViewController.h"
#import "CKTServerCommunicator.h"

@interface CKTAddressCCEntryViewController ()

@end

@implementation CKTAddressCCEntryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)placeOrder:(id)sender
{
    // Post the order to the server
    [CKTServerCommunicator postOrder:self.order delegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dataModelInitialized
{
    // Order posted
}

- (void)dataModelError:(NSError *)error
{
    // Error posting order
}

@end
