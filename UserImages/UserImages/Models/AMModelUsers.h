//
//  AMModelUsers.h
//
//  Created by Karandeep Bhalla on 29/09/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AMData;

@interface AMModelUsers : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) BOOL status;
@property (nonatomic, assign) id message;
@property (nonatomic, strong) AMData *data;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
