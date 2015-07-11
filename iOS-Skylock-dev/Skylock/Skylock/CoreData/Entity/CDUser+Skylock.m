//
//  CDUser+Skylock.m
//  Skylock
//
//  Created by Daniel Ondruj on 24.03.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import "CDUser+Skylock.h"
#import "User.h"
#import "CDBike+Skylock.h"
#import "CDLock+Skylock.h"

@implementation CDUser (Skylock)

- (User*)lockValue
{
    User* entityUser = [[User alloc] init];
    
    entityUser.name = self.first_name;
    entityUser.locks = [[NSMutableArray alloc] init];
    entityUser.bikes = [[NSMutableArray alloc] init];
    
    for(CDBike *bike in self.bikes)
    {
        [entityUser.bikes addObject:[bike bikeValue]];
    }
    
    for(CDLock *lock in self.locks)
    {
        [entityUser.locks addObject:[lock lockValue]];
    }

    return entityUser;
}

@end
