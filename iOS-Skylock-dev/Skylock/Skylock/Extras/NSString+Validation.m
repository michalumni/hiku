//
//  NSString+Validation.m
//  Skylock
//
//  Created by Daniel Ondruj on 09.04.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import "NSString+Validation.h"

@implementation NSString (Validation)

#pragma mark - Email address validation

- (BOOL) isValidEmailAddress {
	
	NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	
	return [pred evaluateWithObject: self];
    
    NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"EmailRegExp" ofType:@"txt"];
    NSString *emailRegex = [NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:NULL];
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}


#pragma mark - Phone number validation

- (BOOL) isValidPhoneNumberUS {
    /*
     NSString *regex = @"[0-9]{3}-[0-9]{3}-[0-9]{4}";
     NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
     
     return [pred evaluateWithObject: self];
     */
    
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber
                                                               error:nil];
    NSUInteger phoneNumberOfMatches = [detector numberOfMatchesInString:self
                                                                options:0
                                                                  range:NSMakeRange(0, [self length])];
    
    return phoneNumberOfMatches;
    
}

-(BOOL)isValidPhoneNumberEuropean
{
    NSString *regex = @"([+]{0,1}|0{2})+[0-9]{0,12}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
    
    return YES;
    
    //@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *phoneRegex = @"*((\\+)|(00))[0-9]{3})+[0-9]{9}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    BOOL phoneValidates = [phoneTest evaluateWithObject:self];
    
    return phoneValidates;
}



- (BOOL) isPartOfPhoneNumber {
    
    int length = self.length;
    
    if (!length) {
        
        return YES;
    }
    
    NSMutableString *regexp = [[NSMutableString alloc] init];
    
    for (int i = 0; i < length; i++) {
        
        if (i<3 || (i>3 && i<7) || (i>7)) {
            
            [regexp appendString: @"[0-9]"];
        }
        else {
            
            [regexp appendString: @"-"];
        }
    }
    
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexp];
	return [pred evaluateWithObject: self];
}

- (BOOL) needDash {
    
    NSString *regex1 = @"[0-9]{3}";
    NSString *regex2 = @"[0-9]{3}-[0-9]{3}";
    
	NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex1];
	NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
    
	return [pred1 evaluateWithObject: self] || [pred2 evaluateWithObject: self];
}


#pragma mark - Empty string

+ (BOOL) isEmptyOrNil : (NSString*) str {
    
	return !str || [[str stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString: @""];
}



#pragma mark - credit card validation

- (NSMutableArray *) toCharArray {
    
	NSMutableArray *characters = [[NSMutableArray alloc] initWithCapacity:[self length]];
	for (int i=0; i < [self length]; i++) {
		NSString *ichar  = [NSString stringWithFormat:@"%c", [self characterAtIndex:i]];
		[characters addObject:ichar];
	}
    
	return characters;
}

+ (BOOL) luhnCheck:(NSString *)stringToTest {
    
	NSMutableArray *stringAsChars = [stringToTest toCharArray];
    
	BOOL isOdd = YES;
	int oddSum = 0;
	int evenSum = 0;
    
	for (int i = [stringToTest length] - 1; i >= 0; i--) {
        
		int digit = [(NSString *)[stringAsChars objectAtIndex:i] intValue];
        
		if (isOdd)
			oddSum += digit;
		else
			evenSum += digit/5 + (2*digit) % 10;
        
		isOdd = !isOdd;
	}
    
	return ((oddSum + evenSum) % 10 == 0);
}

- (BOOL)isValidCardNumber {
    
    return [[self class] luhnCheck:self];
}

@end
