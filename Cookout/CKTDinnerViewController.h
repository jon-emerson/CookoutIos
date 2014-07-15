//
//  CKTDinnerViewController.h
//  Cookout
//
//  Created by Jonathan Emerson on 6/17/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKTDinner.h"
#import "CKTDataModelChangeDelegate.h"

@interface CKTDinnerViewController : UIViewController <CKTDataModelChangeDelegate>

@property (nonatomic, strong) CKTDinner *dinner;

@end
