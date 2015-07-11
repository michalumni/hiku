//
//  CDLock+Skylock.m
//  Skylock
//
//  Created by Daniel Ondruj on 21.03.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import "CDLock+Skylock.h"
#import "Lock.h"

@implementation CDLock (Skylock)

- (Lock*)lockValue
{
    Lock* entityLock = [[Lock alloc] init];
    entityLock.apiID = self.user_id;
    entityLock.localBTID = self.localBTID;
    entityLock.name = self.name;
    entityLock.isDefault = [self.isDefault boolValue];
    
    return entityLock;
}

- (void)updateWithLock:(Lock*)lock
{
    self.user_id = lock.apiID;
    self.localBTID = lock.localBTID;
    self.name = lock.name;
    self.isDefault = [NSNumber numberWithBool:lock.isDefault];
}

@end
