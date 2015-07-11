//
//  NetworkingErrors.m
//  Hungry
//
//  Created by Martin Stava on 9/19/13.
//  Copyright (c) 2013 Martin Stava. All rights reserved.
//

NSString * const NetworkingErrorDomain = @"NetworkingErrorDomain";

NSInteger const InvalidAccessTokenError = -1001;
NSInteger const InvalidObjectError = 123;

#import "NetworkingErrors.h"

@implementation NetworkingErrors


+ (NSError*) errorWithType : (NSString*) type userInfo:(NSDictionary*)userInfo
{
    if ([type isEqualToString: @"InvalidAccessToken"]) {
        
        return [NSError errorWithDomain: NetworkingErrorDomain
                                   code: InvalidAccessTokenError
                               userInfo: userInfo];
    }
    
    return nil;
}


@end
