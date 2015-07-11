//
//  MKMapView+Skylock.m
//  Skylock
//
//  Created by Daniel Ondruj on 31.03.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import "MKMapView+Skylock.h"

@implementation MKMapView (Skylock)

-(void)addAnnotation:(id<MKAnnotation>)annotation animated:(BOOL)shouldAnimate
{
    if (!shouldAnimate)
        [self addAnnotation:annotation];
    else {
        MKAnnotationView *annotationView = [self viewForAnnotation:annotation];
        CGRect endFrame = annotationView.frame;
        endFrame = CGRectMake(
                              annotationView.frame.origin.x,
                              annotationView.frame.origin.y - self.bounds.size.height,
                              annotationView.frame.size.width,
                              annotationView.frame.size.height);
        [UIView animateWithDuration:0.3
                              delay:0.0f
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             annotationView.frame = endFrame;
                         }
                         completion:^(BOOL finished) {
                             [self addAnnotation:annotation];
                         }];
    }
}

- (void)removeAnnotation:(id<MKAnnotation>)annotation animated:(BOOL)shouldAnimate {
    if (!shouldAnimate)
        [self removeAnnotation:annotation];
    else {
        MKAnnotationView *annotationView = [self viewForAnnotation:annotation];
        CGRect endFrame = annotationView.frame;
        endFrame = CGRectMake(
                              annotationView.frame.origin.x,
                              annotationView.frame.origin.y - self.bounds.size.height,
                              annotationView.frame.size.width,
                              annotationView.frame.size.height);
        [UIView animateWithDuration:0.3
                              delay:0.0f
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             annotationView.frame = endFrame;
                         }
                         completion:^(BOOL finished) {
                             [self removeAnnotation:annotation];
                         }];
    }
}

- (void)removeAnnotations:(NSArray *)annotations animated:(BOOL)shouldAnimate {
    if (!shouldAnimate)
        [self removeAnnotations:annotations];
    else {
        NSTimeInterval delay = 0.0;
        for (id<MKAnnotation> annotation in annotations) {
            MKAnnotationView *annotationView = [self viewForAnnotation:annotation];
            CGRect endFrame = annotationView.frame;
            endFrame = CGRectMake(
                                  annotationView.frame.origin.x,
                                  annotationView.frame.origin.y - self.bounds.size.height,
                                  annotationView.frame.size.width,
                                  annotationView.frame.size.height);
            [UIView animateWithDuration:0.3
                                  delay:delay
                                options:UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 annotationView.frame = endFrame;
                             }
                             completion:^(BOOL finished) {
                                 [self removeAnnotation:annotation];
                             }];
            delay += 0.05;
        }
    }
}

@end
