//
//  AMModelUsers.m
//
//  Created by Karandeep Bhalla on 29/09/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "AMModelUsers.h"
#import "AMData.h"


NSString *const kAMModelUsersStatus = @"status";
NSString *const kAMModelUsersMessage = @"message";
NSString *const kAMModelUsersData = @"data";


@interface AMModelUsers ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation AMModelUsers

@synthesize status = _status;
@synthesize message = _message;
@synthesize data = _data;


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
            self.status = [[self objectOrNilForKey:kAMModelUsersStatus fromDictionary:dict] boolValue];
            self.message = [self objectOrNilForKey:kAMModelUsersMessage fromDictionary:dict];
            self.data = [AMData modelObjectWithDictionary:[dict objectForKey:kAMModelUsersData]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithBool:self.status] forKey:kAMModelUsersStatus];
    [mutableDict setValue:self.message forKey:kAMModelUsersMessage];
    [mutableDict setValue:[self.data dictionaryRepresentation] forKey:kAMModelUsersData];

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

    self.status = [aDecoder decodeBoolForKey:kAMModelUsersStatus];
    self.message = [aDecoder decodeObjectForKey:kAMModelUsersMessage];
    self.data = [aDecoder decodeObjectForKey:kAMModelUsersData];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeBool:_status forKey:kAMModelUsersStatus];
    [aCoder encodeObject:_message forKey:kAMModelUsersMessage];
    [aCoder encodeObject:_data forKey:kAMModelUsersData];
}

- (id)copyWithZone:(NSZone *)zone
{
    AMModelUsers *copy = [[AMModelUsers alloc] init];
    
    if (copy) {

        copy.status = self.status;
        copy.message = [self.message copyWithZone:zone];
        copy.data = [self.data copyWithZone:zone];
    }
    
    return copy;
}


@end
