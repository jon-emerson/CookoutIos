//
//  CKTServerCommunicator.m
//  Cookout
//
//  Created by Jonathan Emerson on 6/25/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import "CKTDataModelChangeDelegate.h"
#import "CKTServerCommunicator.h"
#import "CKTDataModelBuilder.h"
#include "CKTOrder.h"

@implementation CKTServerCommunicator

+ (void)initializeDataModel:(id <CKTDataModelChangeDelegate>)delegate
{
    // This is the prefix we must strip from any server response.
    NSString *jsonPrefix = @"&&&PREFIX&&&";

    NSURL *url = [[NSURL alloc] initWithString:@"http://immense-beyond-2989.herokuapp.com/readDinners"];
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url]
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            [delegate dataModelError:error];
        } else {
            NSString *jsonStr = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] substringFromIndex:[jsonPrefix length]];
            [CKTDataModelBuilder populateDataModelFromJSON:jsonStr];
            [delegate dataModelInitialized];
        }
    }];
}

+ (void)postOrder:(CKTOrder *)order delegate:(id <CKTDataModelChangeDelegate>)d
{
    NSURL *url = [[NSURL alloc] initWithString:@"http://immense-beyond-2989.herokuapp.com/order"];
    
    // Send the following things in the post request
    // dinner id, address id, user id, special instructions
    /*[NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url]
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (error) {
                                   [d dataModelError:error];
                               } else {
                                   NSString *jsonStr = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] substringFromIndex:[jsonPrefix length]];
                                   [CKTDataModelBuilder populateDataModelFromJSON:jsonStr];
                                   [d dataModelInitialized];
                               }
                           }];*/

}

@end