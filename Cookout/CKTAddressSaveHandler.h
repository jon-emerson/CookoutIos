//
//  CKTAddressSaveHandler.h
//  Cookout
//
//  Created by Chandrashekar Raghavan on 7/3/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CKTAddressSaveHandler <NSObject>
-(void)addressSaved:(NSDictionary *)responseObject;
-(void)addressSaveFailed:(NSError *)error;
@end
