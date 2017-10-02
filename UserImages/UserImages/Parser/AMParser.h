//
//  AMParser.h
//  IntelliSchool
//
//  Created by macmini1 on 17/12/15.
//  Copyright © 2015 intellinet. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "Constants.h"



@protocol AMParserDelegate
- (void)receivedJSON:(NSData *)objectNotation withAPI:(NSString *)apiMethod;
@optional
- (void)receivedJSON:(NSData *)objectNotation withAPI:(NSString *)apiMethod withTagValue: (int) tagValue;

- (void)failedWithError:(NSError *)error withAPI:(NSString *)apiMethod;

@end

typedef void (^SuccessDataFromServer)(NSData *objectNotation, NSString *urlString);
typedef void (^FailedDataFromServer)(NSError *error, NSString *urlString);

@interface AMParser : NSObject
{
    NSMutableData *_responseData;
    NSString *apiMethod;
    int tagValue;

}
@property (weak, nonatomic) id<AMParserDelegate> delegate;
@property (nonatomic, copy) void (^SuccessDataFromServer)(NSData *successData, NSString *urlString);
@property (nonatomic, copy) void (^FailedDataFromServer)(NSError *FailedData, NSString *urlString);
@property int tagValue;

-(NSString *)prepareAPIStringWithDataForImage : (NSString*)urlPostfix inputDictionary:(NSData *)requestData;


//-(void)searchGroupsAtCoordinate;
-(void)createConnectionRequestForJsonWithURL:(NSString *)urlString WithJsonDictionary:(NSDictionary *)jsonDict;
-(NSDictionary*)prepareAPIStringWithData : (NSString*)urlPostfix inputDictionary:(NSDictionary*)inputDictionary;
/* Multipart data parsing */
-(void)createConnectionRequestForMultipartWithURL:(NSString *)urlString WithData:(NSData *)requestData withExtention:(NSString *)strExtention;

-(void)connectionRequestForJsonWithURL:(NSString *)urlString withJsonDictionary:(NSDictionary *)jsonDict withSuccessCompletionHandler:(SuccessDataFromServer)completionBlock withFailedCompletionHandler:(FailedDataFromServer)failCompletionBlock;
@end
