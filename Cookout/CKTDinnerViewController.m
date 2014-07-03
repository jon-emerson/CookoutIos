//
//  CKTDinnerViewController.m
//  Cookout
//
//  Created by Jonathan Emerson on 6/17/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import "CKTAsyncImageView.h"
#import "CKTChef.h"
#import "CKTDataModel.h"
#import "CKTDinnerViewController.h"
#import "CKTCheckoutViewController.h"
#import "CKTUser.h"
#import "CKTOrder.h"

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
@property (weak, nonatomic) IBOutlet UIView *starRatings;
@property (weak, nonatomic) IBOutlet UILabel *quantityAvailable;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set the default quantity of the dinner order
    self.quantity.text = @"1";

    // Do any additional setup after loading the view from its nib.
    CKTChef *chef = [CKTDataModel.sharedDataModel chefWithId:self.dinner.chefId];
    self.foodImage.imageURL = [self.dinner imageNSUrl];
    self.profileImage.imageURL = [chef imageNSUrl];
    self.foodLabel.text = [self.dinner name];
    self.subtitleLabel.text = [chef name];
    self.descriptionLabel.text = [self.dinner description];
    self.descriptionLabel.numberOfLines = 0;
    [self.descriptionLabel sizeToFit];
    self.price.text = [[NSString alloc] initWithFormat:@"$%@", self.dinner.price];
    NSArray *ingredients = [self.dinner ingredients];
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
