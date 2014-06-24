//
//  CKTDinnerViewController.m
//  Cookout
//
//  Created by Jonathan Emerson on 6/17/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import "CKTAsyncImageView.h"
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.foodImage.imageURL = [self.dinner imageUrl];
    self.profileImage.imageURL = [self.dinner profileImageUrl];
    self.foodLabel.text = [self.dinner name];
    self.subtitleLabel.text = [self.dinner subtitle];
    self.descriptionLabel.text = [self.dinner description];
    self.descriptionLabel.numberOfLines = 0;
    [self.descriptionLabel sizeToFit];
    
    NSArray *ingredients = [self.dinner ingredients];
    if ([ingredients count] > 0) {
        self.ingredientsLabel.text = ingredients[0];
    } else {
        self.ingredientsLabel.text = @"";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
