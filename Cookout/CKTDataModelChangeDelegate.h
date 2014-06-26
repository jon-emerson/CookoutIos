//
//  CKTDataModelChangeDelegate.h
//  Cookout
//
//  Created by Jonathan Emerson on 6/25/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CKTDataModelChangeDelegate <NSObject>
- (void)dataModelInitialized;
- (void)dataModelError:(NSError *)error;
@end
