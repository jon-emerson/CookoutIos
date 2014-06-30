//
//  CKTDataModelBuilder.m
//  Cookout
//
//  Created by Jonathan Emerson on 6/25/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import "CKTDataModel.h"
#import "CKTDataModelBuilder.h"

@implementation CKTDataModelBuilder

+ (void)populateDataModelFromJSON:(NSString *)jsonStr
{
    NSError *localError = nil;
    NSDictionary *parsedObject =
          [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]
                                          options:0
                                            error:&localError];
    if (localError != nil) {
        NSLog(@"JSON error: %@", localError);
        return;
    }

    CKTDataModel *dataModel = [CKTDataModel sharedDataModel];

    NSArray *chefs = [parsedObject valueForKey:@"chefs"];
    NSLog(@"Chef count: %d", chefs.count);
    for (NSDictionary *chefDictionary in chefs) {
        [dataModel addChef:[[CKTChef alloc] initWithDictionary:chefDictionary]];
    }

    NSArray *dinners = [parsedObject valueForKey:@"dinners"];
    NSLog(@"Dinner count: %d", dinners.count);
    for (NSDictionary *dinnerDictionary in dinners) {
        [dataModel addDinner:[[CKTDinner alloc] initWithDictionary:dinnerDictionary]];
    }
}

@end
