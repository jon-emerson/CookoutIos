//
//  CKTDataModel.m
//  Cookout
//
//  Created by Jonathan Emerson on 6/25/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import "CKTDataModel.h"

@interface CKTDataModel ()
@property (nonatomic, retain) NSMutableArray *dinnersArray;
@property (nonatomic, retain) NSMutableDictionary *chefDictionary;
@end

@implementation CKTDataModel

+ (instancetype)sharedDataModel
{
    static CKTDataModel *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CKTDataModel alloc] init];
        
        // Do any other initialization stuff here.
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dinnersArray = [[NSMutableArray alloc] init];
        self.chefDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSArray *)dinners
{
    return [self.dinnersArray copy];
}

- (void)addDinner:(CKTDinner *)dinner
{
    [self.dinnersArray addObject:dinner];
}

- (void)addChef:(CKTChef *)chef
{
    [self.chefDictionary setObject:chef forKey:chef.chefId];
}

- (CKTChef *)chefWithId:(NSString *)id
{
    return [self.chefDictionary valueForKey:id];
}

@end
