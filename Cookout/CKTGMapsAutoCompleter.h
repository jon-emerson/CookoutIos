//
//  CKTGMapsAutoCompleter.h
//  Cookout
//
//  Created by Chandrashekar Raghavan on 7/8/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CKTGMapsAutoCompleter <NSObject>
-(void)autoCompleteSuggestions:(NSDictionary *) suggestions;
-(void)autoCompleteFailed:(NSError *) error;
-(void)placeDetailsReceived:(NSDictionary *)response;
-(void)placeDetailsFailed:(NSError *)error;
@end
