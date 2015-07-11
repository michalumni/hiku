//
//  UserManager.h
//  Skylock
//
//  Created by Daniel Ondruj on 08.04.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkingClient.h"

@interface APIManager : NSObject

+ (APIManager*)sharedInstance;
-(void)loginUser:(NSString *)email withPassword:(NSString *)password withCompletionBlock:(void (^)(NSDictionary *errorDictionary, NSError* error))block;
-(void)signUpUserWithFacebookAccess:(NSString *)accessToken withCompletionBlock:(void (^)(NSDictionary *errorDictionary, NSError* error))block;
-(void)signInUserWithFacebookAccess:(NSString *)accessToken withCompletionBlock:(void (^)(NSDictionary *errorDictionary, NSError* error))block;
-(void)forgotPasswordWithEmail:(NSString *)email withCompletionBlock:(void (^)(NSDictionary *errorDictionary, NSError* error))block;
-(void)updateProfileWithCompletionBlock:(void (^)(NSDictionary *errorDictionary, NSError* error))block;
-(void)signUpUserWithName:(NSString *)name withSurname:(NSString *)surname withEmail:(NSString *)email withPassword:(NSString *)password withConfirmPassword:(NSString *)confirmPassword withGender:(NSString *)gender withPhone:(NSString *)phone withBirth:(NSString *)birth withCompletionBlock:(void (^)(NSDictionary *errorDictionary, NSError* error))block;
- (NSOperation*)requestUpdateAvatarImage:(UIImage*)image completionHandler:(void (^)(NSString *avatarURL, NSError* error))completionHandler;

@property (nonatomic, strong) NetworkingClient *networkingClient;

@end
