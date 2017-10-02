//
//  AMData.h
//
//  Created by Karandeep Bhalla on 29/09/17
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface AMData : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSArray *users;
@property (nonatomic, assign) BOOL hasMore;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
