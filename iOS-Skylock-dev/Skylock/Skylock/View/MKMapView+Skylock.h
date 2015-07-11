//
//  MKMapView+Skylock.h
//  Skylock
//
//  Created by Daniel Ondruj on 31.03.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (Skylock)

- (void)removeAnnotation:(id<MKAnnotation>)annotation animated:(BOOL)shouldAnimate;
- (void)removeAnnotations:(NSArray *)annotations animated:(BOOL)shouldAnimate;

@end
