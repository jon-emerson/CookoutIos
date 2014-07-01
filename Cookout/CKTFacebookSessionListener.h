//
//  CKTFacebookSessionListener.h
//  Cookout
//
//  Created by Jonathan Emerson on 7/1/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CKTFacebookSessionListener <NSObject>

- (void)handleFacebookSessionStateChange;

@end
