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
                           price:(NSNumber *)price
                    numAvailable:(NSNumber *)numAvailable
                 orderByDateTime:(NSDate *)orderByDateTime
                deliveryDateTime:(NSDate *)deliveryDateTime
                     ingredients:(NSArray *)ingredients
                     description:(NSString *)description
{
    self = [super init];
    
    if (self) {
        _dinnerId = dinnerId;
        _name = name;
        _chefId = chefId;
        _imageFilename = imageFilename;
        _price = price;
        _numAvailable = numAvailable;
        _orderByDateTime = orderByDateTime;
        _deliveryDateTime = deliveryDateTime;
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
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate *orderByDateTime = [df dateFromString: [dictionary valueForKey:@"orderByDateTime"]];
    NSDate *deliveryDateTime = [df dateFromString: [dictionary valueForKey:@"deliveryDateTime"]];
    
    return [self initWithDinnerId:[dictionary valueForKey:@"id"]
                             name:[dictionary valueForKey:@"name"]
                           chefId:[dictionary valueForKey:@"chefId"]
                    imageFilename:[dictionary valueForKey:@"imageFilename"]
                            price:[dictionary valueForKey:@"price"]
                     numAvailable:[dictionary valueForKey:@"numAvailable"]
                  orderByDateTime:orderByDateTime
                 deliveryDateTime:deliveryDateTime
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

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_dinnerId forKey:@"dinnerId"];
    [encoder encodeObject:_name forKey:@"name"];
    [encoder encodeObject:_chefId forKey:@"chefId"];
    [encoder encodeObject:_imageFilename forKey:@"imageFilename"];
    [encoder encodeObject:_price forKey:@"price"];
    [encoder encodeObject:_numAvailable forKey:@"numAvailable"];
    [encoder encodeObject:_orderByDateTime forKey:@"orderByDateTime"];
    [encoder encodeObject:_deliveryDateTime forKey:@"deliveryDateTime"];
    [encoder encodeObject:_ingredients forKey:@"ingredients"];
    [encoder encodeObject:_description forKey:@"description"];
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    _dinnerId = [decoder decodeObjectForKey:@"dinnerId"];
    _name = [decoder decodeObjectForKey:@"name"];
    _chefId = [decoder decodeObjectForKey:@"chefId"];
    _imageFilename = [decoder decodeObjectForKey:@"imageFilename"];
    _price = [decoder decodeObjectForKey:@"price"];
    _numAvailable = [decoder decodeObjectForKey:@"numAvailable"];
    _orderByDateTime = [decoder decodeObjectForKey:@"orderByDateTime"];
    _deliveryDateTime = [decoder decodeObjectForKey:@"deliveryDateTime"];
    _ingredients = [decoder decodeObjectForKey:@"ingredients"];
    _description = [decoder decodeObjectForKey:@"description"];
    return self;
}

@end
