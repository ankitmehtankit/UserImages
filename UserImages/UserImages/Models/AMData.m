//
//  AMData.m
//
//  Created by Karandeep Bhalla on 29/09/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "AMData.h"
#import "AMUsers.h"


NSString *const kAMDataUsers = @"users";
NSString *const kAMDataHasMore = @"has_more";


@interface AMData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation AMData

@synthesize users = _users;
@synthesize hasMore = _hasMore;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
    NSObject *receivedAMUsers = [dict objectForKey:kAMDataUsers];
    NSMutableArray *parsedAMUsers = [NSMutableArray array];
    if ([receivedAMUsers isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedAMUsers) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedAMUsers addObject:[AMUsers modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedAMUsers isKindOfClass:[NSDictionary class]]) {
       [parsedAMUsers addObject:[AMUsers modelObjectWithDictionary:(NSDictionary *)receivedAMUsers]];
    }

    self.users = [NSArray arrayWithArray:parsedAMUsers];
            self.hasMore = [[self objectOrNilForKey:kAMDataHasMore fromDictionary:dict] boolValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForUsers = [NSMutableArray array];
    for (NSObject *subArrayObject in self.users) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForUsers addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForUsers addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForUsers] forKey:kAMDataUsers];
    [mutableDict setValue:[NSNumber numberWithBool:self.hasMore] forKey:kAMDataHasMore];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.users = [aDecoder decodeObjectForKey:kAMDataUsers];
    self.hasMore = [aDecoder decodeBoolForKey:kAMDataHasMore];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_users forKey:kAMDataUsers];
    [aCoder encodeBool:_hasMore forKey:kAMDataHasMore];
}

- (id)copyWithZone:(NSZone *)zone
{
    AMData *copy = [[AMData alloc] init];
    
    if (copy) {

        copy.users = [self.users copyWithZone:zone];
        copy.hasMore = self.hasMore;
    }
    
    return copy;
}


@end
