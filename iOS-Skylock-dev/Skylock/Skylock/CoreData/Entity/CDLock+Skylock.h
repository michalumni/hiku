//
//  CDLock+Skylock.h
//  Skylock
//
//  Created by Daniel Ondruj on 21.03.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import "CDLock.h"

@class Lock;

@interface CDLock (Skylock)

- (Lock*)lockValue;
- (void)updateWithLock:(Lock*)lock;

@end
