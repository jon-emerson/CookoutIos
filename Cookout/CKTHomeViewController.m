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

@implementation CKTHomeViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.separatorColor = [UIColor clearColor];
    [CKTServerCommunicator initializeDataModel:self];
}

- (void)dataModelInitialized
{
    NSLog(@"Data model initialized!");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)dataModelError:(NSError *)error
{
    NSLog(@"Data model error: %@", error);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[CKTDataModel sharedDataModel] dinners] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CKTDinnerViewController *dinnerViewController =
    [[CKTDinnerViewController alloc] init];
    
    NSArray *dinners = [[CKTDataModel sharedDataModel] dinners];
    CKTDinner *selectedDinner = dinners[indexPath.row];
    dinnerViewController.dinner = selectedDinner;
    
    [self.navigationController pushViewController:dinnerViewController animated:YES];
}

@end
