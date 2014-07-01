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

@interface CKTDinnerViewController ()
@property (weak, nonatomic) IBOutlet CKTAsyncImageView *foodImage;
@property (weak, nonatomic) IBOutlet CKTAsyncImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *foodLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *ingredientsLabel;

@end

@implementation CKTDinnerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    CKTChef *chef = [CKTDataModel.sharedDataModel chefWithId:self.dinner.chefId];
    self.foodImage.imageURL = [self.dinner imageUrl];
    self.profileImage.imageURL = [chef imageUrl];
    self.foodLabel.text = [self.dinner name];
    self.subtitleLabel.text = [chef name];
    self.descriptionLabel.text = [self.dinner description];
    self.descriptionLabel.numberOfLines = 0;
    [self.descriptionLabel sizeToFit];
    
    NSArray *ingredients = [self.dinner ingredients];
    if ([ingredients count] > 0) {
        self.ingredientsLabel.text = ingredients[0];
    } else {
        self.ingredientsLabel.text = @"";
    }
    
    // Handle autolayout messiness and allow scrolling - create a subview of UIScrollView that
    // contains all the UI elements. (done in XIB). Retrieve parent scroll view
    UIScrollView * scrollView = self.view;
    
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

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
