//
//  CDBike+Skylock.m
//  Skylock
//
//  Created by Daniel Ondruj on 21.03.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import "CDBike+Skylock.h"
#import "Bike.h"

@implementation CDBike (Skylock)

- (Bike*)bikeValue
{
    Bike* entityBike = [[Bike alloc] init];
    entityBike.name = self.name;
    
    return entityBike;
}

- (void)updateWithBike:(Bike*)bike
{
    self.name = bike.name;
}

@end
