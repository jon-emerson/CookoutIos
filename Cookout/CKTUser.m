//
//  CKTUser.m
//  Cookout
//
//  Created by Jonathan Emerson on 6/17/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import "CKTUser.h"

@interface CKTUser ()
@property (nonatomic, strong) NSURL *imageNSUrl;
@end

@implementation CKTUser

- (instancetype)init
{
    return nil;
}

- (instancetype)initWithUserId:(NSString *)userId
                          name:(NSString *)name
                      imageUrl:(NSString *)imageUrl
{
    self = [super init];
    
    if (self) {
        _userId = userId;
        _name = name;
        _imageUrl = imageUrl;
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    NSString *userId = [dictionary valueForKey:@"id"];
    NSString *name = [dictionary valueForKey:@"name"];
    NSString *imageUrl = [dictionary valueForKey:@"imageUrl"];
    return [self initWithUserId:userId name:name imageUrl:imageUrl];
}

- (NSURL *)imageNSUrl {
    if (!_imageNSUrl) {
        _imageNSUrl = [NSURL URLWithString:self.imageUrl];
    }
    return _imageNSUrl;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_userId forKey:@"userId"];
    [encoder encodeObject:_name forKey:@"name"];
    [encoder encodeObject:_imageUrl forKey:@"imageUrl"];
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    _userId = [decoder decodeObjectForKey:@"userId"];
    _name = [decoder decodeObjectForKey:@"name"];
    _imageUrl = [decoder decodeObjectForKey:@"imageUrl"];
    return self;
}

@end
