//
//  CDBike+Skylock.h
//  Skylock
//
//  Created by Daniel Ondruj on 21.03.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import "CDBike.h"

@class Bike;

@interface CDBike (Skylock)

- (Bike*)bikeValue;
- (void)updateWithBike:(Bike*)bike;

@end
