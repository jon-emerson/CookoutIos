//
//  CKTDinnerViewController.m
//  Cookout
//
//  Created by Jonathan Emerson on 6/17/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import "CKTAsyncImageView.h"
#import "CKTCheckoutViewController.h"
#import "CKTCurrentUser.h"
#import "CKTDataModel.h"
#import "CKTDinnerViewController.h"
#import "CKTServerCommunicator.h"
#import "CKTOrder.h"
#import "CKTUser.h"

@interface CKTDinnerViewController ()
@property (weak, nonatomic) IBOutlet CKTAsyncImageView *foodImage;
@property (weak, nonatomic) IBOutlet CKTAsyncImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *foodLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *ingredientsLabel;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIStepper *quantityStepper;
@property (weak, nonatomic) IBOutlet UITextField *quantity;
@property (weak, nonatomic) IBOutlet UIButton *orderButton;
@property (weak, nonatomic) IBOutlet UIButton *wishlistButton;
@property (weak, nonatomic) IBOutlet UIView *starRatings;
@property (weak, nonatomic) IBOutlet UILabel *quantityAvailable;

-(IBAction)placeOrder:(id)sender;
-(IBAction)incrementDecrementOrder:(id)sender;
-(IBAction)addToWishlist:(id)sender;
@end

@implementation CKTDinnerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Today's Specials";
    }
    return self;
}

- (IBAction)incrementDecrementOrder:(id)sender
{
    // Handle increment & decrement of order size
    NSNumber *stepperValue = [NSNumber numberWithDouble:self.quantityStepper.value];
    self.quantity.text = [stepperValue stringValue];
}

- (IBAction)placeOrder:(id)sender
{
    // Handle order button hit
    
    // Create an instance of the CKTCheckoutViewController and push
    // it on the nav controller stack
    CKTCheckoutViewController *checkout = [[CKTCheckoutViewController alloc] init];
    
    // Create an order object to capture the order state
    CKTOrder *newOrder = [[CKTOrder alloc]init];
    newOrder.dinner = self.dinner;
    newOrder.orderQuantity = [[NSNumber alloc] initWithDouble:self.quantityStepper.value];
    
    // Setup user entity in order
    // newOrder.user = self.user;
    checkout.order = newOrder;
    [self.navigationController pushViewController:checkout animated:YES];
}

- (IBAction)addToWishlist:(id)sender
{
    // If the dinner has run out then add it to the wishlist
    UIAlertView * newAlert = [[UIAlertView alloc]init];
    newAlert.message = @"We'll add this dish to your wishlist and let you know the next time it's made";
    [newAlert addButtonWithTitle:@"Ok"];
    [newAlert show];
    return;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Register as a listener to data model changes
    [CKTServerCommunicator addSyncListener:self];
    
    // Do any additional setup after loading the view from its nib.
    CKTUser *chef = [CKTDataModel.sharedDataModel userWithId:self.dinner.chefId];
    self.foodImage.imageURL = [self.dinner imageNSUrl];
    self.profileImage.imageURL = [chef imageNSUrl];
    self.foodLabel.text = [self.dinner name];
    self.subtitleLabel.text = [chef name];
    self.descriptionLabel.text = [self.dinner description];
    self.descriptionLabel.numberOfLines = 0;
    [self.descriptionLabel sizeToFit];
    self.price.text = [[NSString alloc] initWithFormat:@"$%@", self.dinner.price];
    NSArray *ingredients = [self.dinner ingredients];
    
    
    // Setup available dinner quantity
    if([self.dinner dinnersAvailable]>0)
    {
        self.quantity.text = @"1";
        self.quantity.hidden = false;
        self.quantityStepper.hidden = false;
        self.orderButton.hidden = false;
        self.wishlistButton.hidden = true;
        self.quantityStepper.maximumValue = [self.dinner dinnersAvailable];
        self.quantityAvailable.text = [[NSString alloc] initWithFormat:@"%d meals still available",[self.dinner dinnersAvailable]];
    }
    else
    {
        self.quantity.hidden = true;
        self.quantityStepper.hidden = true;
        self.orderButton.hidden = true;
        self.wishlistButton.hidden = false;
        self.quantityAvailable.text = [[NSString alloc] initWithFormat:@"Sold out!"];

    }
    
    if ([ingredients count] > 0) {
        self.ingredientsLabel.text = ingredients[0];
    } else {
        self.ingredientsLabel.text = @"";
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
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]
                                initWithTitle:@" "
                                style:UIBarButtonItemStyleBordered
                                target:self
                                action:nil];
    self.navigationController.navigationBar.topItem.backBarButtonItem=btnBack;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

- (void)dataModelInitialized
{
    // Sync with the cookout server completed
    // the data model may have been updated.
    NSLog(@"Data model synced!");
    dispatch_async(dispatch_get_main_queue(), ^{
        // Reload the view
        [self viewDidLoad];
    });
}

- (void)dataModelError:(NSError *)error
{
    NSLog(@"Data model error: %@", error);
}
@end
