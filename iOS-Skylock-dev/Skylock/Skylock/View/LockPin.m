//
//  LockPin.m
//  Skylock
//
//  Created by Daniel Ondruj on 31.03.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import "LockPin.h"

@implementation LockPin

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    
    //[self willChangeValueForKey:@"coordinate"];
    _theCoordinate = newCoordinate;
    //[self didChangeValueForKey:@"coordinate"];
}

- (CLLocationCoordinate2D)coordinate
{
    return _theCoordinate;
}

- (NSString *)title
{
    return @"";
}

@end

