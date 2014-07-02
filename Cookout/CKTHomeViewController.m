//
//  CKTHomeViewController.m
//  Cookout
//
//  Created by Jonathan Emerson on 6/16/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import "CKTDataModel.h"
#import "CKTDataModelChangeDelegate.h"
#import "CKTDinner.h"
#import "CKTDinnerViewController.h"
#import "CKTHomeViewController.h"
#import "CKTHomeViewCell.h"
#import "CKTServerCommunicator.h"
#import "CKTFacebookSessionManager.h"


@implementation CKTHomeViewController

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self) {
        
        // Listen for Facebook sesssion updates
        [[CKTFacebookSessionManager sharedFacebookSessionManager] addListener:self];

        // Setup the navbar for the home view
        UINavigationItem *navItem = self.navigationItem;
        
        // Add the cookout logo as the titleView
        UIImage *image = [UIImage imageNamed:@"cookout-logo-160.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        navItem.titleView = imageView;
        
        // Add the settings pane as the left bar button item
        navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"\u2630"
                                                                     style: UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(openSettingsMenu)];
        // Add the login button as a right bar button item
        navItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Login"
                                                                      style: UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(handleLoginRequest:)];
    }
    return self;
}

- (void)handleFacebookSessionStateChange
{
    FBSession *session = [[CKTFacebookSessionManager sharedFacebookSessionManager] session];
    NSLog(@"facebook state change: %u", session.state);
    
    
    if (session.isOpen) {
        [FBRequestConnection startForMeWithCompletionHandler:
         ^(FBRequestConnection *connection, id<FBGraphUser> result, NSError *error) {
             if (!error) {
                 NSString *helloStr = [NSString stringWithFormat:@"Hi %@!", [result first_name]];
                 self.navigationItem.rightBarButtonItem.title = helloStr;
             } else {
                 // An error occurred, we need to handle the error
                 // See: https://developers.facebook.com/docs/ios/errors
                 self.navigationItem.rightBarButtonItem.title = @"Login";
             }
         }];
    } else {
        self.navigationItem.rightBarButtonItem.title = @"Login";
    }
}

- (void)handleLoginRequest:(UIButton*)sender
{
    [[CKTFacebookSessionManager sharedFacebookSessionManager] login];
}

- (void) openSettingsMenu
{
    // Logic for opening and displaying the settings menu in the homescreen
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 210;
}

- (NSURL *)makeUrl:(NSString *)filename
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",
                                 @"http://cookout-assets.s3-website-us-east-1.amazonaws.com/",
                                 filename]];
}

- (void) viewDidLoad {
    [super viewDidLoad];

    self.tableView.separatorColor = [UIColor clearColor];
    [CKTServerCommunicator initializeDataModel:self];
}

- (void) dataModelInitialized
{
    NSLog(@"Data model initialized!");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void) dataModelError:(NSError *)error
{
    NSLog(@"Data model error: %@", error);
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[CKTDataModel sharedDataModel] dinners] count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"homeViewCell";
    CKTHomeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"CKTHomeViewCell" bundle:nil]
                forCellReuseIdentifier:CellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    NSArray *dinners = [[CKTDataModel sharedDataModel] dinners];
    [cell populate:dinners[indexPath.row]];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CKTDinnerViewController *dinnerViewController =
    [[CKTDinnerViewController alloc] init];
    
    NSArray *dinners = [[CKTDataModel sharedDataModel] dinners];
    CKTDinner *selectedDinner = dinners[indexPath.row];
    dinnerViewController.dinner = selectedDinner;
    
    [self.navigationController pushViewController:dinnerViewController animated:YES];
}




@end
