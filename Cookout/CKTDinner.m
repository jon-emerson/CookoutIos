//
//  CKTDinner.m
//  Cookout
//
//  Created by Jonathan Emerson on 6/17/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import "CKTDinner.h"

@interface CKTDinner ()
@property (nonatomic, strong) NSURL *imageNSUrl;
@end

@implementation CKTDinner

- (instancetype)init
{
    return nil;
}

- (instancetype)initWithDinnerId:(NSString *)dinnerId
                            name:(NSString *)name
                          chefId:(NSString *)chefId
                        imageUrl:(NSString *)imageUrl
                           price:(NSNumber *)price
                        quantity:(NSNumber *)quantity
                 quantityOrdered: (NSNumber *) quantityOrdered
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
        _imageUrl = imageUrl;
        _price = price;
        _quantity = quantity;
        _quantityOrdered = quantityOrdered;
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
    NSDate *orderByDateTime = [df dateFromString:[dictionary valueForKey:@"orderByDateTime"]];
    NSDate *deliveryDateTime = [df dateFromString:[dictionary valueForKey:@"deliveryDateTime"]];
    
    return [self initWithDinnerId:[dictionary valueForKey:@"id"]
                             name:[dictionary valueForKey:@"name"]
                           chefId:[dictionary valueForKey:@"chefId"]
                         imageUrl:[dictionary valueForKey:@"imageUrl"]
                            price:[dictionary valueForKey:@"price"]
                     quantity:[dictionary valueForKey:@"quantity"]
                  quantityOrdered: [dictionary valueForKey:@"quantityOrdered"]
                  orderByDateTime:orderByDateTime
                 deliveryDateTime:deliveryDateTime
                      ingredients:ingredients
                      description:[dictionary valueForKey:@"description"]];
}

- (NSURL *)imageNSUrl {
    if (!_imageNSUrl) {
        _imageNSUrl = [NSURL URLWithString:self.imageUrl];
    }
    return _imageNSUrl;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_dinnerId forKey:@"dinnerId"];
    [encoder encodeObject:_name forKey:@"name"];
    [encoder encodeObject:_chefId forKey:@"chefId"];
    [encoder encodeObject:_imageUrl forKey:@"imageUrl"];
    [encoder encodeObject:_price forKey:@"price"];
    [encoder encodeObject:_quantity forKey:@"quantity"];
    [encoder encodeObject:_quantityOrdered forKey:@"quantityOrdered"];
    [encoder encodeObject:_orderByDateTime forKey:@"orderByDateTime"];
    [encoder encodeObject:_deliveryDateTime forKey:@"deliveryDateTime"];
    [encoder encodeObject:_ingredients forKey:@"ingredients"];
    [encoder encodeObject:_description forKey:@"description"];
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    _dinnerId = [decoder decodeObjectForKey:@"dinnerId"];
    _name = [decoder decodeObjectForKey:@"name"];
    _chefId = [decoder decodeObjectForKey:@"chefId"];
    _imageUrl = [decoder decodeObjectForKey:@"imageUrl"];
    _price = [decoder decodeObjectForKey:@"price"];
    _quantity = [decoder decodeObjectForKey:@"quantity"];
    _quantityOrdered = [decoder decodeObjectForKey:@"quantityOrdered"];
    _orderByDateTime = [decoder decodeObjectForKey:@"orderByDateTime"];
    _deliveryDateTime = [decoder decodeObjectForKey:@"deliveryDateTime"];
    _ingredients = [decoder decodeObjectForKey:@"ingredients"];
    _description = [decoder decodeObjectForKey:@"description"];
    return self;
}

// Returns the number of meals available to order
-(int)dinnersAvailable
{
    return self.quantity.intValue - self.quantityOrdered.intValue;
}

@end
