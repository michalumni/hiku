//
//  NetworkingErrors.h
//  Hungry
//
//  Created by Martin Stava on 9/19/13.
//  Copyright (c) 2013 Martin Stava. All rights reserved.
//

extern NSString * const NetworkingErrorDomain;

extern NSInteger const InvalidAccessTokenError;
extern NSInteger const InvalidObjectError;

#import <Foundation/Foundation.h>

@interface NetworkingErrors : NSObject

+ (NSError*) errorWithType : (NSString*) type userInfo:(NSDictionary*)userInfo;

@end
