//
//  CKTAddressCCEntryViewController.h
//  Cookout
//
//  Created by Chandrashekar Raghavan on 7/2/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKTDataModelChangeDelegate.h"
#import "CKTOrder.h"

@interface CKTAddressCCEntryViewController : UIViewController <CKTDataModelChangeDelegate>
@property (weak, nonatomic) CKTOrder * order;
- (IBAction)placeOrder:(id) sender;
@end
