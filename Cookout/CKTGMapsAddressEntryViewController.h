//
//  CKTGMapsAddressEntryViewController.h
//  Cookout
//
//  Created by Chandrashekar Raghavan on 7/7/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKTGMapsAutoCompleter.h"
#import "CKTAddressSaveHandler.h"
#import "CKTAddressUpdateHandler.h"
#import "CKTAddress.h"

@interface CKTGMapsAddressEntryViewController : UIViewController <UITextFieldDelegate,CKTGMapsAutoCompleter,CKTAddressSaveHandler,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) id<CKTAddressUpdateHandler> delegate;
@property (nonatomic) int selectedIndex;
@property (nonatomic) BOOL showRecent;
@property (nonatomic, strong) CKTAddress *addressContainer;
@end
