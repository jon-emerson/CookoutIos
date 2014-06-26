//
//  CKTServerCommunicator.h
//  Cookout
//
//  Created by Jonathan Emerson on 6/25/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "CKTDataModelChangeDelegate.h"

@interface CKTServerCommunicator : NSObject
+ (void)initializeDataModel:(id <CKTDataModelChangeDelegate>)delegate;
@end