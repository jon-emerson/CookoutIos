//
//  CKTDataModel.m
//  Cookout
//
//  Created by Jonathan Emerson on 6/25/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import "CKTCurrentUser.h"
#import "CKTDataModel.h"

@interface CKTDataModel ()
@property (nonatomic, retain) NSMutableArray *dinnersArray;
@property (nonatomic, retain) NSMutableDictionary *userDictionary;
@end

@implementation CKTDataModel

+ (instancetype)sharedDataModel
{
    static CKTDataModel *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [NSKeyedUnarchiver unarchiveObjectWithFile:[CKTDataModel itemArchivePath]];
        if (!sharedInstance) {
            NSLog(@"Didn't find a local data model - creating a new one");
            sharedInstance = [[CKTDataModel alloc] init];
        }
        else NSLog(@"Local data model restored!");
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dinnersArray = [[NSMutableArray alloc] init];
        _userDictionary = [[NSMutableDictionary alloc] init];
        
        // TODO(anyone): DO NOT allocate this client-side.  Variables here
        // should be a reflection of the client-side.  If the server-side has
        // no notion of who the current user is, this should be nil.
        _currentUser = [[CKTCurrentUser alloc] init];
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

- (void)addUser:(CKTUser *)user
{
    [self.userDictionary setObject:user forKey:user.userId];
}

- (CKTUser *)userWithId:(NSString *)id
{
    return [self.userDictionary valueForKey:id];
}

- (void)setSession:(NSString *)sId
{
    self.currentUser.sessionId = [sId copy];
}

- (void)addAddress:(CKTAddress *)address
{
    if (!self.currentUser.addresses) {
        self.currentUser.addresses = [[NSMutableArray alloc] init];
    }
    [self.currentUser.addresses addObject:address];
}

+ (NSString *)itemArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    // NOTE(jon): Not sure if I like the pattern of serializing it exactly
    // how it exists in memory, or whether I'd rather serialize the data
    // items directly, then rebuild the indexes on each read.  The latter
    // has the advantage that we can build new indexes in the future that
    // work after user upgrades.  But just throwing everything out and re-
    // fetching it from the server isn't that bad.
    [encoder encodeObject:_dinnersArray forKey:@"dinnersArray"];
    [encoder encodeObject:_userDictionary forKey:@"userDictionary"];
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    _dinnersArray = [decoder decodeObjectForKey:@"dinnersArray"];
    _userDictionary = [decoder decodeObjectForKey:@"userDictionary"];
    return self;
}

- (BOOL)saveToDisk {
    NSLog(@"Saving data model to local disk");
    return [NSKeyedArchiver archiveRootObject:self toFile:[CKTDataModel itemArchivePath]];
}

@end
