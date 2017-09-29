//
//  AMParser.m
//  IntelliSchool
//
//  Created by macmini1 on 17/12/15.
//  Copyright © 2015 intellinet. All rights reserved.
//

#import "AMParser.h"

@implementation AMParser
@synthesize delegate;
@synthesize tagValue;

/* Using Multipart */

-(void)createConnectionRequestForMultipartWithURL:(NSString *)urlString WithData:(NSData *)requestData withExtention:(NSString *)strExtention {
    
    apiMethod = urlString;
    
    if (strExtention.length == 0) {
        strExtention = @"jpg";
    }
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",k_URL_CommonMultipartURLString,urlString]]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"ipodfile.%@\"\r\n",strExtention] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:requestData]];
    
    {
        [self logStringInTesting:[NSString stringWithFormat:@"URL==>> %@%@",k_URL_CommonURLString,urlString]];
        NSString *jsonString = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
        [self logStringInTesting:jsonString];
    }
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    request.timeoutInterval = 120.0f;
    if ([NSURLConnection canHandleRequest:request]) {
        NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        [connection start];
    }
    else{
        [self logStringInTesting:@"Request Not Possible"];
    }
}

-(void)createConnectionRequestForJsonWithURL:(NSString *)urlString WithJsonDictionary:(NSDictionary *)jsonDict {
    NSError *jsonError;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:jsonDict options:NSUTF8StringEncoding error:&jsonError];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",k_URL_CommonURLString,urlString]];
    apiMethod = urlString;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    request.timeoutInterval = 60.0f;
    
     {
        [self logStringInTesting:[NSString stringWithFormat:@"URL==>> %@%@",k_URL_CommonURLString,urlString]];
        NSString *jsonString = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
        [self logStringInTesting:jsonString];
    }
    if ([NSURLConnection canHandleRequest:request]) {
        NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        [connection start];
    }
    else{
        [self logStringInTesting:@"Request Not Possible"];
    }
}

-(void)connectionRequestForJsonWithURL:(NSString *)urlString withJsonDictionary:(NSDictionary *)jsonDict withSuccessCompletionHandler:(SuccessDataFromServer)completionBlock withFailedCompletionHandler:(FailedDataFromServer)failCompletionBlock {
    NSError *jsonError;
    _SuccessDataFromServer = completionBlock;
    _FailedDataFromServer = failCompletionBlock;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:jsonDict options:NSUTF8StringEncoding error:&jsonError];
    {
        [self logStringInTesting:[NSString stringWithFormat:@"URL==>> %@offset=%@&limit=10",k_URL_CommonURLString,urlString]];
        NSString *jsonString = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
        [self logStringInTesting:jsonString];//http://sd2-hiring.herokuapp.com/api/users?offset=10&limit=10
    }
    NSString* urlTextEscaped = [[NSString stringWithFormat:@"%@offset=%@&limit=10",k_URL_CommonURLString,urlString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSURL *url = [NSURL URLWithString:urlTextEscaped];
    apiMethod = urlString;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setHTTPBody: requestData];
    
    
    
    if ([NSURLConnection canHandleRequest:request]) {
        NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        [connection start];
    }
    else{
        [self logStringInTesting:@"Request Not Possible"];
    }
    
    
    
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
    {
        NSString *jsonString = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
        [self logStringInTesting:[NSString stringWithFormat:@"Output For %@ ==> %@", apiMethod,jsonString]];
    }

    [delegate receivedJSON:_responseData withAPI:apiMethod];

    if (tagValue != 0) {
        [delegate receivedJSON:_responseData withAPI:apiMethod withTagValue:tagValue];
    }
    
    
    if (_SuccessDataFromServer != nil) {
        _SuccessDataFromServer(_responseData, apiMethod);
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    [delegate failedWithError:error withAPI:apiMethod];
    if (_FailedDataFromServer != nil) {
        _FailedDataFromServer(error,apiMethod);
    }
}

-(NSDictionary*)prepareAPIStringWithData : (NSString*)urlPostfix inputDictionary:(NSDictionary*)inputDictionary
{
    [self logStringInTesting:@"call WS."];
   
    NSString *urlString = [NSString stringWithFormat:@"%@%@",k_URL_CommonURLString,urlPostfix];
    
    NSError *error = nil;
    
    NSData *jsonInputData = [NSJSONSerialization dataWithJSONObject:inputDictionary options:NSJSONWritingPrettyPrinted error:&error];
    
    {
        [self logStringInTesting:[NSString stringWithFormat:@"URL==>> %@%@",k_URL_CommonURLString,urlPostfix]];
        NSString *jsonString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
        [self logStringInTesting:[NSString stringWithFormat:@"Input Json ==>> %@", jsonString]];
    }
    NSString *jsonInputString = [[NSString alloc] initWithData:jsonInputData encoding:NSUTF8StringEncoding];
    
    NSDictionary *dict;
    dict= [self runAPI:urlString jsonString:jsonInputString];
    return dict;
}

-(NSString *)prepareAPIStringWithDataForImage : (NSString*)urlPostfix inputDictionary:(NSData *)requestData
{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",k_URL_CommonMultipartURLString,urlPostfix]]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"ipodfile.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:requestData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    request.timeoutInterval = 120.0f;
    
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    if (responseData == nil) {
        return @"";
    }
    NSString* newStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    return newStr;
    
//    NSString *stringWithData = [NSString stringWithUTF8String:[responseData bytes]];
//    return stringWithData
}

-(NSDictionary*)runAPI:(NSString*)urlString jsonString:(NSString*)jsonString
{
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    request.timeoutInterval = 60.0f;
    
    [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    NSError *e;
    if (responseData == nil) {
        return nil;
    }
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&e];
    
    return dict;
}
-(NSString *)runAPIForImage:(NSString*)urlString jsonString:(NSString*)jsonString
{
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    request.timeoutInterval = 60.0f;
    
    [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    if (responseData == nil) {
        return @"";
    }
    NSString *stringWithData = [NSString stringWithUTF8String:[responseData bytes]];
    return stringWithData;
}

-(void) logStringInTesting:(NSString *)str {
    if (k_BoolTestMode) {
        NSLog(@"AMParser- %@",str);
    }
}
@end
