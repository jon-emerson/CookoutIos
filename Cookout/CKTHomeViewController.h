//
//  CKTHomeViewController.h
//  Cookout
//
//  Created by Jonathan Emerson on 6/16/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKTDataModelChangeDelegate.h"
#import "CKTFacebookSessionListener.h"

@interface CKTHomeViewController : UITableViewController <CKTFacebookSessionListener, CKTDataModelChangeDelegate>

@end
