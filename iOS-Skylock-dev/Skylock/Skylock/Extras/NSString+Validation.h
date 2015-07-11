//
//  NSString+Validation.h
//  Skylock
//
//  Created by Daniel Ondruj on 09.04.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Validation)

- (BOOL) isValidEmailAddress;


#pragma mark - Phone number validation

- (BOOL) isValidPhoneNumberUS;
- (BOOL) isValidPhoneNumberEuropean;
- (BOOL) isPartOfPhoneNumber;
- (BOOL) isValidCardNumber;
+ (BOOL) isEmptyOrNil : (NSString*) str;

@end
