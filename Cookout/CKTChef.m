//
//  CKTChef.m
//  Cookout
//
//  Created by Jonathan Emerson on 6/17/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import "CKTChef.h"

@interface CKTChef ()
@property (nonatomic, strong) NSURL *imageUrl;
@end

@implementation CKTChef

- (instancetype)init
{
    return nil;
}

- (instancetype)initWithChefId:(NSString *)chefId
                          name:(NSString *)name
                 imageFilename:(NSString *)imageFilename
{
    self = [super init];
    
    if (self) {
        _chefId = chefId;
        _name = name;
        _imageFilename = imageFilename;
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    NSString *chefId = [dictionary valueForKey:@"id"];
    NSString *name = [dictionary valueForKey:@"name"];
    NSString *imageFilename = [dictionary valueForKey:@"imageFilename"];
    return [self initWithChefId:chefId name:name imageFilename:imageFilename];
}

- (NSURL *)imageUrl {
    if (!_imageUrl) {
        _imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",
                                              @"http://cookout-assets.s3-website-us-east-1.amazonaws.com/",
                                              self.imageFilename]];
    }
    return _imageUrl;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_chefId forKey:@"chefId"];
    [encoder encodeObject:_name forKey:@"name"];
    [encoder encodeObject:_imageFilename forKey:@"imageFilename"];
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    _chefId = [decoder decodeObjectForKey:@"chefId"];
    _name = [decoder decodeObjectForKey:@"name"];
    _imageFilename = [decoder decodeObjectForKey:@"imageFilename"];
    return self;
}

@end
