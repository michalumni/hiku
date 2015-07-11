//
//  UserManager.m
//  Skylock
//
//  Created by Daniel Ondruj on 08.04.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import "APIManager.h"
#import "AFHTTPRequestOperation.h"
#import "AFNetworkActivityIndicatorManager.h"
#import <AFNetworking.h>
#import "CoreDataService.h"

@implementation APIManager

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

+ (APIManager*)sharedInstance
{
    static APIManager* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[APIManager alloc] init];
    });
    
    return instance;
}

-(void)loginUser:(NSString *)email withPassword:(NSString *)password withCompletionBlock:(void (^)(NSDictionary *errorDictionary, NSError* error))block
{
    // it all starts with a manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // in my case, I'm in prototype mode, I own the network being used currently,
    // so I can use a self generated cert key, and the following line allows me to use that
    manager.securityPolicy.allowInvalidCertificates = YES;
    // Make sure we a JSON serialization policy, not sure what the default is
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // No matter the serializer, they all inherit a battery of header setting APIs
    // Here we do Basic Auth, never do this outside of HTTPS
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    
    NSMutableDictionary* requestParams = [NSMutableDictionary dictionary];
    [requestParams setValue:email forKey:@"email"];
    [requestParams setValue:password forKey:@"password"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@api/v1/account/login", API_URL];
    
    [manager POST:urlString parameters:requestParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonDict = (NSDictionary *) responseObject;
        NSDictionary *jsonHeaderDict = [[operation response] allHeaderFields];
        
        NSLog(@"%@", jsonDict);
        if([jsonDict objectForKey:@"error"] != nil)
        {
            block(jsonDict, nil);
        }
        else
        {
            [[SkylockDataManager sharedInstance] openUserSessionWithDataDictionary:jsonDict withXAppToken:[jsonHeaderDict objectForKey:@"X-App-Token"]];
            
            block(nil, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
}

-(void)signUpUserWithName:(NSString *)name withSurname:(NSString *)surname withEmail:(NSString *)email withPassword:(NSString *)password withConfirmPassword:(NSString *)confirmPassword withGender:(NSString *)gender withPhone:(NSString *)phone withBirth:(NSString *)birth withCompletionBlock:(void (^)(NSDictionary *errorDictionary, NSError* error))block
{
    // it all starts with a manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // in my case, I'm in prototype mode, I own the network being used currently,
    // so I can use a self generated cert key, and the following line allows me to use that
    manager.securityPolicy.allowInvalidCertificates = YES;
    // Make sure we a JSON serialization policy, not sure what the default is
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // No matter the serializer, they all inherit a battery of header setting APIs
    // Here we do Basic Auth, never do this outside of HTTPS
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    
//    "first_name": "Name",
//    "last_name": "Surname",
//    "phone": "123456789",
//    "email": "name@example.com",
//    "password": "1234",
//    "gender": "male",
//    "birth": "2/23/1980"
    
    NSMutableDictionary* requestParams = [NSMutableDictionary dictionary];
    [requestParams setValue:name forKey:@"first_name"];
    [requestParams setValue:surname forKey:@"last_name"];
    [requestParams setValue:email forKey:@"email"];
    [requestParams setValue:password forKey:@"password"];
    [requestParams setValue:confirmPassword forKey:@"confirm_password"];
    [requestParams setValue:[gender lowercaseString] forKey:@"gender"];
    [requestParams setValue:phone forKey:@"phone"];
    [requestParams setValue:birth forKey:@"birth"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@api/v1/account/signup", API_URL];
    
    [manager POST:urlString parameters:requestParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonDict = (NSDictionary *) responseObject;
        NSDictionary *jsonHeaderDict = [[operation response] allHeaderFields];
        
        NSLog(@"%@", jsonDict);
        if([jsonDict objectForKey:@"error"] != nil)
        {
            block(jsonDict, nil);
        }
        else
        {
            [[SkylockDataManager sharedInstance] openUserSessionWithDataDictionary:jsonDict withXAppToken:[jsonHeaderDict objectForKey:@"X-App-Token"]];
            
            block(nil, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
}

-(void)signUpUserWithFacebookAccess:(NSString *)accessToken withCompletionBlock:(void (^)(NSDictionary *errorDictionary, NSError* error))block
{
    // it all starts with a manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // in my case, I'm in prototype mode, I own the network being used currently,
    // so I can use a self generated cert key, and the following line allows me to use that
    manager.securityPolicy.allowInvalidCertificates = YES;
    // Make sure we a JSON serialization policy, not sure what the default is
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // No matter the serializer, they all inherit a battery of header setting APIs
    // Here we do Basic Auth, never do this outside of HTTPS
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    
    NSMutableDictionary* requestParams = [NSMutableDictionary dictionary];
    [requestParams setValue:accessToken forKey:@"facebook_access_token"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@api/v1/account/facebook-signup", API_URL];
    
    [manager POST:urlString parameters:requestParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonDict = (NSDictionary *) responseObject;
        NSDictionary *jsonHeaderDict = [[operation response] allHeaderFields];
        
        NSLog(@"%@", jsonDict);
        if([jsonDict objectForKey:@"error"] != nil)
        {
            block(jsonDict, nil);
        }
        else
        {
            [[SkylockDataManager sharedInstance] openUserSessionWithDataDictionary:jsonDict withXAppToken:[jsonHeaderDict objectForKey:@"X-App-Token"]];
            
            block(nil, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
}

-(void)signInUserWithFacebookAccess:(NSString *)accessToken withCompletionBlock:(void (^)(NSDictionary *errorDictionary, NSError* error))block
{
    // it all starts with a manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // in my case, I'm in prototype mode, I own the network being used currently,
    // so I can use a self generated cert key, and the following line allows me to use that
    manager.securityPolicy.allowInvalidCertificates = YES;
    // Make sure we a JSON serialization policy, not sure what the default is
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // No matter the serializer, they all inherit a battery of header setting APIs
    // Here we do Basic Auth, never do this outside of HTTPS
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    
    NSMutableDictionary* requestParams = [NSMutableDictionary dictionary];
    [requestParams setValue:accessToken forKey:@"facebook_access_token"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@api/v1/account/facebook-login", API_URL];
    
    [manager POST:urlString parameters:requestParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonDict = (NSDictionary *) responseObject;
        NSDictionary *jsonHeaderDict = [[operation response] allHeaderFields];
        
        NSLog(@"%@", jsonDict);
        if([jsonDict objectForKey:@"error"] != nil)
        {
            block(jsonDict, nil);
        }
        else
        {
            [[SkylockDataManager sharedInstance] openUserSessionWithDataDictionary:jsonDict withXAppToken:[jsonHeaderDict objectForKey:@"X-App-Token"]];
            
            block(nil, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
    
}

-(void)forgotPasswordWithEmail:(NSString *)email withCompletionBlock:(void (^)(NSDictionary *errorDictionary, NSError* error))block
{
    // it all starts with a manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // in my case, I'm in prototype mode, I own the network being used currently,
    // so I can use a self generated cert key, and the following line allows me to use that
    manager.securityPolicy.allowInvalidCertificates = YES;
    // Make sure we a JSON serialization policy, not sure what the default is
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // No matter the serializer, they all inherit a battery of header setting APIs
    // Here we do Basic Auth, never do this outside of HTTPS
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    
    NSMutableDictionary* requestParams = [NSMutableDictionary dictionary];
    [requestParams setValue:email forKey:@"email"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@api/v1/account/forgot-password", API_URL];
    
    [manager POST:urlString parameters:requestParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *jsonDict = (NSDictionary *) responseObject;
        
        NSLog(@"%@", jsonDict);
        if([jsonDict objectForKey:@"error"] != nil)
        {
            block(jsonDict, nil);
        }
        else
        {
            block(nil, nil);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
}

-(void)updateProfileWithCompletionBlock:(void (^)(NSDictionary *errorDictionary, NSError* error))block
{
    // it all starts with a manager
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // in my case, I'm in prototype mode, I own the network being used currently,
    // so I can use a self generated cert key, and the following line allows me to use that
    manager.securityPolicy.allowInvalidCertificates = YES;
    // Make sure we a JSON serialization policy, not sure what the default is
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // No matter the serializer, they all inherit a battery of header setting APIs
    // Here we do Basic Auth, never do this outside of HTTPS
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:[[SkylockDataManager sharedInstance] user].api_token forHTTPHeaderField:@"X-App-Token"];
    manager.requestSerializer = requestSerializer;
    
    NSString *urlString = [NSString stringWithFormat:@"%@api/v1/account/profile", API_URL];
    
    [manager POST:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *jsonDict = (NSDictionary *) responseObject;
        
        NSLog(@"%@", jsonDict);
        if([jsonDict objectForKey:@"error"] != nil)
        {
            block(jsonDict, nil);
        }
        else
        {
            [[SkylockDataManager sharedInstance] updateUserWithDataDictionary:jsonDict];
            block(nil, nil);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
}

- (NSOperation*)requestUpdateAvatarImage:(UIImage*)image completionHandler:(void (^)(NSString *avatarURL, NSError* error))completionHandler {
    
    NetworkingClient* networkingClient = self.networkingClient;
   
    NSString* URLString = [[NSURL URLWithString:@"user/avatar" relativeToURL:networkingClient.baseURL] absoluteString];
    
    NSError* error;
    NSData *imageData = UIImagePNGRepresentation(image);
    NSMutableURLRequest* request = [networkingClient.requestSerializer
                                    multipartFormRequestWithMethod:@"POST" URLString:URLString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"avatar" fileName:@"dummy.png" mimeType:@"image/png"];
    } error:&error];
    
    if (error != nil) {
        if (completionHandler) {
            completionHandler(nil, error);
        }
        return nil;
    }
    
    [request setValue:[[SkylockDataManager sharedInstance] user].api_token forHTTPHeaderField:@"X-App-Token"];
//    [request setValue:[[AccountService sharedInstance] deviceId] forHTTPHeaderField:@"X-Device-ID"];
    
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    NSLog(@"RequestURL: %@", [request.URL absoluteString]);
    
    AFHTTPRequestOperation *operation = [networkingClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id JSON) {
        
        NSLog(@"requestUpdateAvatarImage: %@", JSON);
        
        NSError* error;//[BaseEntity errorFromServerResponse:JSON];
        if (error != nil) {
            if (completionHandler) {
                completionHandler(nil, error);
            }
            return;
        }
        
        NSString* avatarURL = JSON[@"avatar_url"];
        
        if (completionHandler) {
            completionHandler(avatarURL, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (completionHandler) {
            completionHandler(nil, error);
        }
    }];
    
    [networkingClient.operationQueue addOperation:operation];
    
    return (NSOperation*)operation;
}

//- (NSMutableURLRequest *)POSTRequestForImage:(NSString *)imagePath ForPrepfile:(NSString *)objectId
//{
//    NSData *imageData = UIImagePNGRepresentation([UIImage imageWithContentsOfFile:imagePath]);
//    NSURL *url = [[NSURL alloc] initFileURLWithPath:[imagePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    if (imageData == nil) {
//        NSLog(@"no data");
//    }
//    NSString *imageName = [imagePath lastPathComponent];
//    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:imageName, @"filename", objectId, @"objectId", nil];
//    NSLog(@"imagename: %@", imageName);
//    
//    NSMutableURLRequest *request = [self multipartFormRequestWithMethod:@"POST" path:@"images" parameters:parameters constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
//        [formData appendPartWithFileData:imageData name:@"image" fileName:imageName mimeType:@"image/png"];
//    }];
//    NSLog(@"picture request fileurl: %@", url);
//    return request;
//}

#pragma mark - Networking client

- (NetworkingClient*)networkingClient
{
    if (_networkingClient == nil) {
        
        NSURL *baseURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@api/v1", API_URL]];
        
        _networkingClient = [[NetworkingClient alloc] initWithBaseURL: baseURL];
        
        _networkingClient.requestSerializer = [AFJSONRequestSerializer serializer];
        _networkingClient.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    }
    
    return _networkingClient;
}


@end
