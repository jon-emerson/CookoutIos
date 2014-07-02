//
//  CKTCheckoutViewController.m
//  Cookout
//
//  Created by Chandrashekar Raghavan on 7/1/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import "CKTCheckoutViewController.h"
#import "CKTAsyncImageView.h"

@interface CKTCheckoutViewController ()
@property (nonatomic, weak) IBOutlet UILabel * orderQuantity;
@property (nonatomic, weak) IBOutlet UILabel * totalPrice;
@property (weak, nonatomic) IBOutlet CKTAsyncImageView *foodImage;
@property (nonatomic, weak) IBOutlet UILabel * foodLabel;   
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
    // Do any additional setup after loading the view from its nib.
    // Display order summary
    self.orderQuantity.text = [[NSString alloc] initWithFormat:@"%@ x", self.order.orderQuantity.stringValue];
    self.foodImage.imageURL = [self.order.dinner imageUrl];
    self.totalPrice.text = [[NSString alloc] initWithFormat:@"$%.2f", ([self.order.dinner.price floatValue]*[self.order.orderQuantity floatValue])];
    self.foodLabel.text = [self.order.dinner name];
    
    // See if user is signed in - if not prompt sign in
     NSObject * user = [[CKTDataModel sharedDataModel] getUser];
    
    if (user) {
        // User is signed in - yaay!
        NSLog(@"User name is %@",user);
    }
    
    
    // If signed in, check if delivery address and credit card information
    // are available for the user. If not prompt entry of address and CC
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
