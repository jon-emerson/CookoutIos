//
//  CKTDinner.m
//  Cookout
//
//  Created by Jonathan Emerson on 6/17/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import "CKTDinner.h"

@interface CKTDinner ()
@property (nonatomic, strong) NSURL *imageUrl;
@end

@implementation CKTDinner

- (instancetype)init
{
    return nil;
}

- (instancetype)initWithDinnerId:(NSString *)dinnerId
                            name:(NSString *)name
                          chefId:(NSString *)chefId
                   imageFilename:(NSString *)imageFilename
                     ingredients:(NSArray *)ingredients
                     description:(NSString *)description
{
    self = [super init];
    
    if (self) {
        _dinnerId = dinnerId;
        _name = name;
        _chefId = chefId;
        _imageFilename = imageFilename;
        _ingredients = ingredients;
        _description = description;
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    NSMutableArray *ingredients = [[NSMutableArray alloc] init];
    if ([dictionary valueForKey:@"ingredients"]) {
        [ingredients addObjectsFromArray:[dictionary valueForKey:@"ingredients"]];
    }
    return [self initWithDinnerId:[dictionary valueForKey:@"id"]
                             name:[dictionary valueForKey:@"name"]
                           chefId:[dictionary valueForKey:@"chefId"]
                    imageFilename:[dictionary valueForKey:@"imageFilename"]
                      ingredients:ingredients
                      description:[dictionary valueForKey:@"description"]];
}

- (NSURL *)imageUrl {
    if (!_imageUrl) {
        _imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",
                          @"http://cookout-assets.s3-website-us-east-1.amazonaws.com/",
                          self.imageFilename]];
    }
    return _imageUrl;
}

@end
