//
//  NetworkingClient.m
//  Hungry
//
//  Created by Martin Stava on 9/19/13.
//  Copyright (c) 2013 Martin Stava. All rights reserved.
//

#import "NetworkingClient.h"
#import "NetworkingErrors.h"

@implementation NetworkingClient


#pragma mark - Utils

+ (NSDictionary*)dictionaryFromJSONString:(NSString*)JSON
{
    NSError* error;
    
    NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:[JSON dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    if (error || !dictionary)
    {
        return nil;
    }
    
    return dictionary;
}


#pragma mark - API Level Errors

- (NSError*)sanitizeError:(NSError*)error forOperation:(AFHTTPRequestOperation*)operation
{
    //if (error.domain == AFNetworkingErrorDomain) {
        
        if (error.code == NSURLErrorBadServerResponse) {
            
            if (operation.response.statusCode == 400) {
                
                NSDictionary *dictionary = [NetworkingClient dictionaryFromJSONString:operation.responseString];
                
                if (dictionary) {
                    
                    NSDictionary *errorDict = dictionary[@"error"];
                    
                    if (errorDict) {
                        
                        NSString *type = errorDict[@"type"];
                        
                        if (type) {
                            
                            NSMutableDictionary* userInfo = [NSMutableDictionary new];
                            if (errorDict[@"message"]) {
                                userInfo[NSLocalizedDescriptionKey] = errorDict[@"message"];
                            }
                            if (operation.response.URL) {
                                userInfo[NSURLErrorFailingURLStringErrorKey] = operation.response.URL.description;
                            }
                            
                            NSError *apiError = [NetworkingErrors errorWithType: type userInfo:userInfo];
                            
                            if (apiError) {
                                
                                return apiError;
                            }
                        }
                    }
                }
            }
        }
    //}
    
    return error;
}


#pragma mark - Making HTTP requests

- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)urlRequest
                                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    __weak typeof(self) weakSelf = self;
    
    return [super HTTPRequestOperationWithRequest:urlRequest success:success failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSError *sanitizedError = [weakSelf sanitizeError: error forOperation: operation];
        
        if (failure) {
            
            failure(operation, sanitizedError);
        }
    }];
}

@end
