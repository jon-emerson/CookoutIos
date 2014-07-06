//
//  CKTDataModel.m
//  Cookout
//
//  Created by Jonathan Emerson on 6/25/14.
//  Copyright (c) 2014 Cookout. All rights reserved.
//

#import "CKTDataModel.h"
#import "CKTUser.h"

@interface CKTDataModel ()
@property (nonatomic, retain) NSMutableArray *dinnersArray;
@property (nonatomic, retain) NSMutableDictionary *chefDictionary;
@property (nonatomic, retain) CKTUser * user;
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
        self.dinnersArray = [[NSMutableArray alloc] init];
        self.chefDictionary = [[NSMutableDictionary alloc] init];
        self.user = [[CKTUser alloc]init];
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

- (void)addChef:(CKTChef *)chef
{
    [self.chefDictionary setObject:chef forKey:chef.chefId];
}

- (CKTChef *)chefWithId:(NSString *)id
{
    return [self.chefDictionary valueForKey:id];
}

- (void) addUser:(CKTUser *) u
{
    //self.user = u;
}

-(void) setSession: (NSString *) sId
{
    self.user.sessionId = [sId copy];
}

-(void) addAddress: (CKTAddress *) address
{
    if(!self.user.addresses)
        self.user.addresses = [[NSMutableArray alloc]init];
    [self.user.addresses addObject:address];
}

- (CKTUser *) getUser
{
    return self.user;
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
    [encoder encodeObject:_chefDictionary forKey:@"chefDictionary"];
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    _dinnersArray = [decoder decodeObjectForKey:@"dinnersArray"];
    _chefDictionary = [decoder decodeObjectForKey:@"chefDictionary"];
    return self;
}

- (BOOL)saveToDisk {
    NSLog(@"Saving data model to local disk");
    return [NSKeyedArchiver archiveRootObject:self toFile:[CKTDataModel itemArchivePath]];
}

@end
