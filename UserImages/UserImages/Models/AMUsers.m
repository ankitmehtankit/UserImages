//
//  AMUsers.m
//
//  Created by Karandeep Bhalla on 29/09/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "AMUsers.h"


NSString *const kAMUsersName = @"name";
NSString *const kAMUsersImage = @"image";
NSString *const kAMUsersItems = @"items";


@interface AMUsers ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation AMUsers

@synthesize name = _name;
@synthesize image = _image;
@synthesize items = _items;


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
            self.name = [self objectOrNilForKey:kAMUsersName fromDictionary:dict];
            self.image = [self objectOrNilForKey:kAMUsersImage fromDictionary:dict];
            self.items = [self objectOrNilForKey:kAMUsersItems fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.name forKey:kAMUsersName];
    [mutableDict setValue:self.image forKey:kAMUsersImage];
    NSMutableArray *tempArrayForItems = [NSMutableArray array];
    for (NSObject *subArrayObject in self.items) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForItems addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForItems addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForItems] forKey:kAMUsersItems];

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

    self.name = [aDecoder decodeObjectForKey:kAMUsersName];
    self.image = [aDecoder decodeObjectForKey:kAMUsersImage];
    self.items = [aDecoder decodeObjectForKey:kAMUsersItems];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_name forKey:kAMUsersName];
    [aCoder encodeObject:_image forKey:kAMUsersImage];
    [aCoder encodeObject:_items forKey:kAMUsersItems];
}

- (id)copyWithZone:(NSZone *)zone
{
    AMUsers *copy = [[AMUsers alloc] init];
    
    if (copy) {

        copy.name = [self.name copyWithZone:zone];
        copy.image = [self.image copyWithZone:zone];
        copy.items = [self.items copyWithZone:zone];
    }
    
    return copy;
}


@end
