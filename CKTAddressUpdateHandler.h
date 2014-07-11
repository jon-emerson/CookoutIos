//
//  CKTAddressUpdateHandler.h
//  Cookout
//
//  Created by Chandrashekar Raghavan on 7/10/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CKTAddressUpdateHandler <NSObject>
-(void) addressUpdated:(int) selectedIndex;
@end
