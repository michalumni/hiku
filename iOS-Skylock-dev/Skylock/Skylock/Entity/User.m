//
//  User.m
//  Skylock
//
//  Created by Daniel Ondruj on 21.03.14.
//  Copyright (c) 2014 uLikeIT s.r.o. All rights reserved.
//

#import "User.h"
#import "CDUser.h"
#import "CDBike+Skylock.h"
#import "CDLock+Skylock.h"

@implementation User

-(id)initWithCDUser:(CDUser *)user
{
    self = [super init];
    if(self)
    {
        _name = user.first_name;
        _locks = [[NSMutableArray alloc] init];
        _bikes = [[NSMutableArray alloc] init];
        
        for(CDBike *bike in user.bikes)
        {
            [_bikes addObject:[bike bikeValue]];
        }
        
        for(CDLock *lock in user.locks)
        {
            [_locks addObject:[lock lockValue]];
        }
    }
    
    return self;
}

@end
