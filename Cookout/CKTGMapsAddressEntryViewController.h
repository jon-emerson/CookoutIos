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

@interface CKTGMapsAddressEntryViewController : UIViewController <UITextFieldDelegate,CKTGMapsAutoCompleter,CKTAddressSaveHandler>
@end
