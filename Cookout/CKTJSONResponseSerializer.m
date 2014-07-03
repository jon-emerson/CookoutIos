//
//  CKTJSONResponseSerializer.m
//  Cookout
//
//  Created by Jonathan Emerson on 7/3/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import "CKTJSONResponseSerializer.h"

@implementation CKTJSONResponseSerializer

// This method overrides AFNetworking's default JSONResponseSerializer to
// remove the JSON hijacking prefix.  For more info, read this!
// http://blackbe.lt/safely-handling-json-hijacking-prevention-methods-with-jquery/
- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    NSString *hijackingPrefix = @"&&&PREFIX&&&";
    int prefixLength = hijackingPrefix.length;
    NSString *responseString = [[NSString alloc] initWithData:data encoding:self.stringEncoding];
    if ([responseString hasPrefix:hijackingPrefix]) {
        return [super responseObjectForResponse:response
                                           data:[data subdataWithRange:NSMakeRange(prefixLength, data.length - prefixLength)]
                                          error:error];
    } else {
        return [super responseObjectForResponse:response
                                           data:data
                                          error:error];
    }
}

@end
