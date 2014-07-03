//
//  CKTChef.m
//  Cookout
//
//  Created by Jonathan Emerson on 6/17/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import "CKTChef.h"

@interface CKTChef ()
@property (nonatomic, strong) NSURL *imageNSUrl;
@end

@implementation CKTChef

- (instancetype)init
{
    return nil;
}

- (instancetype)initWithChefId:(NSString *)chefId
                          name:(NSString *)name
                      imageUrl:(NSString *)imageUrl
{
    self = [super init];
    
    if (self) {
        _chefId = chefId;
        _name = name;
        _imageUrl = imageUrl;
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    NSString *chefId = [dictionary valueForKey:@"id"];
    NSString *name = [dictionary valueForKey:@"name"];
    NSString *imageUrl = [dictionary valueForKey:@"imageUrl"];
    return [self initWithChefId:chefId name:name imageUrl:imageUrl];
}

- (NSURL *)imageNSUrl {
    if (!_imageNSUrl) {
        _imageNSUrl = [NSURL URLWithString:self.imageUrl];
    }
    return _imageNSUrl;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_chefId forKey:@"chefId"];
    [encoder encodeObject:_name forKey:@"name"];
    [encoder encodeObject:_imageUrl forKey:@"imageUrl"];
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    _chefId = [decoder decodeObjectForKey:@"chefId"];
    _name = [decoder decodeObjectForKey:@"name"];
    _imageUrl = [decoder decodeObjectForKey:@"imageUrl"];
    return self;
}

@end
