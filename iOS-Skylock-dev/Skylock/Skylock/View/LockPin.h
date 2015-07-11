//
//  LockPin.h
//  Skylock
//
//  Created by Daniel Ondruj on 31.03.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface LockPin : NSObject <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D theCoordinate;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end
