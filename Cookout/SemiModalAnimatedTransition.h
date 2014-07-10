//
//  SemiModalAnimatedTransition.h
//  Cookout
//
//  Created by Chandrashekar Raghavan on 7/9/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SemiModalAnimatedTransition : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign) BOOL presenting;
@end