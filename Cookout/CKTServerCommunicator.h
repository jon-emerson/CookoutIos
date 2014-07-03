//
//  CKTServerCommunicator.h
//  Cookout
//
//  Created by Jonathan Emerson on 6/25/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "CKTDataModelChangeDelegate.h"
#import "CKTOrder.h"

@interface CKTServerCommunicator : NSObject
+ (void)initializeDataModel:(id<CKTDataModelChangeDelegate>)dataModelChangeDelegate;
+ (void)postOrder:(CKTOrder *)order delegate:(id<CKTDataModelChangeDelegate>)dataModelChangeDelegate;
@end
